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

      String rawAccumulated = '';
      bool handledToolCall = false;

      await for (final response in _chat!.generateChatResponseAsync()) {
        if (response is TextResponse) {
          final token = response.token;
          if (token.isEmpty) continue;
          rawAccumulated += token;
          currentMessages = List<ChatMessage>.from(currentMessages);
          currentMessages[currentMessages.length - 1] =
              currentMessages.last.copyWith(
            text: _decodeEscapes(rawAccumulated),
          );
          emit(state.copyWith(messages: currentMessages));
        } else if (response is FunctionCallResponse) {
          handledToolCall = true;

          final msgsBeforeTool = List<ChatMessage>.from(currentMessages)
            ..removeLast();
          final toolUse = toolDispatcher!.resolve(response);
          final msgsWithChip = [
            ...msgsBeforeTool,
            ChatMessage(
              text: toolUse.message,
              isUser: false,
              isSystemMessage: true,
            ),
          ];
          currentMessages = msgsWithChip;
          emit(state.copyWith(messages: currentMessages));

          final toolResult = await toolUse.execute();
          AppLogger.debug('Tool result: $toolResult');

          await _chat!.addQueryChunk(Message.toolResponse(
            toolName: response.name,
            response: toolResult,
          ));

          // A tool may hand back a ready-to-show message (e.g. a completion
          // summary). Display it verbatim and skip the model follow-up turn,
          // which small models render unreliably after a tool call.
          final displayMessage = toolResult['display_message'];
          if (displayMessage is String && displayMessage.isNotEmpty) {
            currentMessages = [
              ...msgsWithChip,
              ChatMessage(text: displayMessage, isUser: false),
            ];
            emit(state.copyWith(
              messages: currentMessages,
              isGenerating: false,
            ));
            continue;
          }

          currentMessages = [
            ...msgsWithChip,
            const ChatMessage(text: '', isUser: false, isStreaming: true),
          ];
          emit(state.copyWith(messages: currentMessages));

          String finalAccumulated = '';
          await for (final finalResponse
              in _chat!.generateChatResponseAsync()) {
            if (finalResponse is! TextResponse) continue;
            final token = finalResponse.token;
            if (token.isEmpty) continue;
            finalAccumulated += token;
            currentMessages = List<ChatMessage>.from(currentMessages);
            currentMessages[currentMessages.length - 1] =
                currentMessages.last.copyWith(
              text: _decodeEscapes(finalAccumulated),
            );
            emit(state.copyWith(messages: currentMessages));
          }

          currentMessages = List<ChatMessage>.from(currentMessages);
          currentMessages[currentMessages.length - 1] =
              currentMessages.last.copyWith(
            text: _decodeEscapes(finalAccumulated),
            isStreaming: false,
          );
          emit(state.copyWith(
            messages: currentMessages,
            isGenerating: false,
          ));
        }
      }

      if (!handledToolCall) {
        currentMessages = List<ChatMessage>.from(currentMessages);
        currentMessages[currentMessages.length - 1] =
            currentMessages.last.copyWith(
          text: _decodeEscapes(rawAccumulated),
          isStreaming: false,
        );
        emit(state.copyWith(
          messages: currentMessages,
          isGenerating: false,
        ));
        AppLogger.debug('Chat stream completed');
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
