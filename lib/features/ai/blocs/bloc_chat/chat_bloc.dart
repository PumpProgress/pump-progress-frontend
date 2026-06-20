// lib/features/ai/blocs/bloc_chat/chat_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_event_bus.dart';

part 'chat_event.dart';
part 'chat_state.dart';

final _escapeSequencePattern = RegExp(r'\\(n|t|r|\\|")');

String _decodeEscapes(String token) => token.replaceAllMapped(
      _escapeSequencePattern,
      (m) => switch (m.group(1)) {
        'n' => '\n',
        't' => '\t',
        'r' => '\r',
        '\\' => '\\',
        '"' => '"',
        _ => m.group(0)!,
      },
    );

abstract class BaseChatBloc extends Bloc<ChatEvent, ChatState> {
  BaseChatBloc({required GemmaModelService modelService})
      : _modelService = modelService,
        super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<_ChatModelReadyEvent>(_onModelReady);
    _subscribeToModel();
  }

  final GemmaModelService _modelService;
  InferenceChat? _chat;
  StreamSubscription<InferenceModel>? _modelSub;
  bool _systemPromptSent = false;

  /// System prompt sent to the model before the first user message.
  /// Not shown in the UI message list.
  String get systemPrompt;

  /// Tool definitions available to this chat. Return [] if none needed.
  List<Tool> get tools;

  /// Tool dispatcher for resolving FunctionCallResponse. Return null if [tools] is empty.
  AiToolDispatcher? get toolDispatcher;

  void _subscribeToModel() {
    if (_modelService.hasActiveModel) {
      add(_ChatModelReadyEvent(_modelService.model!));
    }
    _modelSub = _modelService.modelStream.listen((model) {
      add(_ChatModelReadyEvent(model));
    });
  }

  Future<void> _onModelReady(
    _ChatModelReadyEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await toolDispatcher?.init();
      _chat = await event.model.createChat(
        supportsFunctionCalls: tools.isNotEmpty,
        tools: tools,
        modelType: ModelType.gemma4,
      );

      // The system prompt is folded into the first user turn (see
      // _onSendMessage) rather than sent as a standalone leading model turn:
      // gemma's chat template expects the conversation to start with a user
      // turn, and a leading model turn degrades instruction-following.
      emit(state.copyWith(isReady: true));
    } catch (e, st) {
      AppLogger.error('Chat init failed: $e', stackTrace: st, error: e);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.isReady || _chat == null) return;

    var currentMessages = [
      ...state.messages,
      ChatMessage(text: event.prompt, isUser: true),
    ];
    emit(state.copyWith(messages: currentMessages, isGenerating: true));
    currentMessages = [
      ...currentMessages,
      const ChatMessage(text: '', isUser: false, isStreaming: true),
    ];
    emit(state.copyWith(messages: currentMessages));

    try {
      // Fold the system prompt into the first user message so the model gets
      // it as part of a proper opening user turn. Only the raw prompt is shown
      // in the UI (added above); the model sees prompt + system text.
      final modelText = !_systemPromptSent && systemPrompt.isNotEmpty
          ? '$systemPrompt\n\n${event.prompt}'
          : event.prompt;
      _systemPromptSent = true;
      await _chat!.addQueryChunk(
        Message.text(text: modelText, isUser: true),
      );

      // Agentic tool-use loop. Each iteration streams one model turn into the
      // trailing placeholder message. If the turn ends with a tool call we run
      // it, feed the result back, and loop so the model can call another tool
      // or produce its final answer. Small models build a plan across several
      // tool calls (e.g. looking up exercises one muscle at a time), so a
      // single tool call per user turn is not enough.
      while (true) {
        String accumulated = '';
        final pendingCalls = <FunctionCallResponse>[];

        await for (final response in _chat!.generateChatResponseAsync()) {
          if (response is TextResponse) {
            final token = response.token;
            if (token.isEmpty) continue;
            accumulated += token;
            currentMessages = List<ChatMessage>.from(currentMessages);
            currentMessages[currentMessages.length - 1] =
                currentMessages.last.copyWith(
              text: _decodeEscapes(accumulated),
            );
            emit(state.copyWith(messages: currentMessages));
          } else if (response is FunctionCallResponse) {
            pendingCalls.add(response);
            break;
          } else if (response is ParallelFunctionCallResponse) {
            // gemma4 batches several calls from one turn into a single
            // response. Dispatch them all, not just the first.
            pendingCalls.addAll(response.calls);
            break;
          }
        }

        // No tool call this turn: the model is done. Finalize the streaming
        // placeholder with the text it produced and stop.
        if (pendingCalls.isEmpty) {
          currentMessages = List<ChatMessage>.from(currentMessages);
          currentMessages[currentMessages.length - 1] =
              currentMessages.last.copyWith(
            text: _decodeEscapes(accumulated),
            isStreaming: false,
          );
          emit(state.copyWith(
            messages: currentMessages,
            isGenerating: false,
          ));
          AppLogger.debug('Chat stream completed');
          break;
        }

        // Drop the streaming placeholder: for gemma4 it holds the raw tool-call
        // JSON that leaked onto the text channel, which must never be shown.
        currentMessages = List<ChatMessage>.from(currentMessages)..removeLast();

        // Run each requested tool, showing a chip and feeding its result back.
        // A tool may hand back a ready-to-show message (e.g. a completion
        // summary); capture it and stop after the batch rather than letting the
        // model take another (unreliable) follow-up turn.
        String? terminalMessage;
        for (final call in pendingCalls) {
          final toolUse = toolDispatcher!.resolve(call);
          currentMessages = [
            ...currentMessages,
            ChatMessage(
              text: toolUse.message,
              isUser: false,
              isSystemMessage: true,
            ),
          ];
          emit(state.copyWith(messages: currentMessages));

          final toolResult = await toolUse.execute();
          AppLogger.debug('Tool result: $toolResult');

          await _chat!.addQueryChunk(Message.toolResponse(
            toolName: call.name,
            response: toolResult,
          ));

          final displayMessage = toolResult['display_message'];
          if (displayMessage is String && displayMessage.isNotEmpty) {
            terminalMessage = displayMessage;
          }
        }

        if (terminalMessage != null) {
          currentMessages = [
            ...currentMessages,
            ChatMessage(text: terminalMessage, isUser: false),
          ];
          emit(state.copyWith(
            messages: currentMessages,
            isGenerating: false,
          ));
          break;
        }

        // Open a fresh streaming placeholder and loop for the next model turn.
        currentMessages = [
          ...currentMessages,
          const ChatMessage(text: '', isUser: false, isStreaming: true),
        ];
        emit(state.copyWith(messages: currentMessages));
      }
    } catch (e, st) {
      AppLogger.error('SendMessage error: $e', stackTrace: st, error: e);
      ErrorEventBus.emitError(e.toString());
      emit(state.copyWith(isGenerating: false, messages: currentMessages));
    }
  }

  @override
  Future<void> close() {
    _modelSub?.cancel();
    return super.close();
  }
}
