import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'ai_event.dart';
part 'ai_state.dart';

// Regex that matches any recognised backslash escape sequence in one pass.
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

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc({required AiToolDispatcher toolDispatcher})
      : _toolDispatcher = toolDispatcher,
        super(AiState()) {
    on<AiInitEvent>(_onAiInitEvent);
    on<SendPromptEvent>(_onSendPromptEvent);
  }

  final AiToolDispatcher _toolDispatcher;
  InferenceChat? _chat;

  Future<void> _onAiInitEvent(AiInitEvent event, Emitter<AiState> emit) async {
    await runSafeEvent(emit, state, AiStatusError.new, () async {
      AppLogger.debug('Initializing AI Bloc: Installing model...');
      emit(state.copyWith(status: AiStatusInstalling()));

      await FlutterGemma.installModel(
        modelType: ModelType.gemma4,
        fileType: ModelFileType.litertlm,
      )
          .fromNetwork(
        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm',
      )
          .withProgress((progress) {
        AppLogger.debug('Downloading: $progress%');
        emit(state.copyWith(downloadProgress: progress));
      }).install();

      final model = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.gpu,
      );
      _chat = await model.createChat(
        supportsFunctionCalls: true,
        tools: AiToolDispatcher.tools,
        modelType: ModelType.gemma4,
      );

      AppLogger.debug('AI Bloc initialized: Model installed successfully');
      emit(state.copyWith(status: AiStatusLoaded()));
    });
  }

  Future<void> _onSendPromptEvent(
      SendPromptEvent event, Emitter<AiState> emit) async {
    if (state.status is! AiStatusLoaded) {
      AppLogger.debug(
          'AI Bloc: Cannot send prompt, model not loaded. Current status: ${state.status}');
      return;
    }

    await runSafeEvent(emit, state, AiStatusError.new, () async {
      // Append user message and initial streaming placeholder.
      emit(state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: event.prompt, isUser: true),
        ],
        isGenerating: true,
      ));
      emit(state.copyWith(
        messages: [
          ...state.messages,
          const ChatMessage(text: '', isUser: false, isStreaming: true),
        ],
      ));

      await _chat!.addQueryChunk(Message.text(
        text: event.prompt,
        isUser: true,
      ));

      String rawAccumulated = '';
      bool handledToolCall = false;

      await for (final response in _chat!.generateChatResponseAsync()) {
        if (response is TextResponse) {
          final token = response.token;
          if (token.isEmpty) continue;
          rawAccumulated += token;
          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[updatedMessages.length - 1] =
              updatedMessages.last
                  .copyWith(text: _decodeEscapes(rawAccumulated));
          emit(state.copyWith(messages: updatedMessages));
        } else if (response is FunctionCallResponse) {
          handledToolCall = true;

          // Remove the streaming placeholder.
          final msgsBeforeTool = List<ChatMessage>.from(state.messages)
            ..removeLast();

          // Show a status chip while the tool runs.
          final muscle =
              response.args['muscle'] as String? ?? 'muscle';
          emit(state.copyWith(messages: [
            ...msgsBeforeTool,
            ChatMessage(
              text: 'Fetching exercises for "$muscle"...',
              isUser: false,
              isSystemMessage: true,
            ),
          ]));

          // Execute the tool via the dispatcher.
          final toolResult = await _toolDispatcher.dispatch(response);
          AppLogger.debug('Tool result: $toolResult');

          // Feed the result back to the model.
          await _chat!.addQueryChunk(Message.toolResponse(
            toolName: response.name,
            response: toolResult,
          ));

          // Append a fresh streaming placeholder for the final response.
          emit(state.copyWith(
            messages: [
              ...state.messages,
              const ChatMessage(text: '', isUser: false, isStreaming: true),
            ],
          ));

          // Stream the model's final response.
          String finalAccumulated = '';
          await for (final finalResponse
              in _chat!.generateChatResponseAsync()) {
            if (finalResponse is! TextResponse) continue;
            final token = finalResponse.token;
            if (token.isEmpty) continue;
            finalAccumulated += token;
            final updatedMessages = List<ChatMessage>.from(state.messages);
            updatedMessages[updatedMessages.length - 1] =
                updatedMessages.last
                    .copyWith(text: _decodeEscapes(finalAccumulated));
            emit(state.copyWith(messages: updatedMessages));
          }

          // Finalise the last message.
          final finalMessages = List<ChatMessage>.from(state.messages);
          finalMessages[finalMessages.length - 1] =
              finalMessages.last.copyWith(
            text: _decodeEscapes(finalAccumulated),
            isStreaming: false,
          );
          emit(state.copyWith(
            messages: finalMessages,
            isGenerating: false,
          ));
        }
      }

      // Pure text response — finalise the streaming placeholder normally.
      if (!handledToolCall) {
        final finalMessages = List<ChatMessage>.from(state.messages);
        finalMessages[finalMessages.length - 1] =
            finalMessages.last.copyWith(
          text: _decodeEscapes(rawAccumulated),
          isStreaming: false,
        );
        emit(state.copyWith(
          messages: finalMessages,
          isGenerating: false,
        ));
        AppLogger.debug('AI Bloc: Stream completed');
      }
    });
  }
}
