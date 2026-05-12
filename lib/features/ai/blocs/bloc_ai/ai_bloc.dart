import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc() : super(AiState()) {
    on<AiInitEvent>(_onAiInitEvent);
    on<SendPromptEvent>(_onSendPromptEvent);
  }
  Future<void> _onAiInitEvent(AiInitEvent event, Emitter<AiState> emit) async {
    await runSafeEvent(emit, state, AiStatusError.new, () async {
      AppLogger.debug('Initializing AI Bloc: Installing model...');
      emit(state.copyWith(status: AiStatusInstalling()));

      await FlutterGemma.installModel(
        modelType: ModelType.gemmaIt,
      )
          .fromNetwork(
        'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
      )
          .withProgress((progress) {
        AppLogger.debug('Downloading: $progress%');
        emit(state.copyWith(downloadProgress: progress));
      }).install();

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
      // Add user message and mark generating
      emit(state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: event.prompt, isUser: true),
        ],
        isGenerating: true,
      ));

      // Add empty AI placeholder message
      emit(state.copyWith(
        messages: [
          ...state.messages,
          const ChatMessage(text: '', isUser: false, isStreaming: true),
        ],
      ));

      AppLogger.debug('AI Bloc: Creating model with configuration...');
      final model = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.gpu,
      );

      final chat = await model.createChat();
      await chat.addQueryChunk(Message.text(
        text: event.prompt,
        isUser: true,
      ));

      String accumulatedText = '';
      final responseStream = chat.generateChatResponseAsync();

      await for (final response in responseStream) {
        String token = '';
        if (response is TextResponse) {
          token = response.token;
          AppLogger.debug('📝 AI Bloc: Token: "${response.token}"');
        } else if (response is ThinkingResponse) {
          AppLogger.debug('💭 AI Bloc: Thinking: ${response.content}');
          continue;
        } else if (response is FunctionCallResponse) {
          AppLogger.debug('🔧 AI Bloc: Function call: ${response.name}');
          continue;
        }

        if (token.isNotEmpty) {
          accumulatedText += token;
          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[updatedMessages.length - 1] =
              updatedMessages.last.copyWith(text: accumulatedText);
          emit(state.copyWith(messages: updatedMessages));
        }
      }

      // Finalize: mark streaming done, re-enable input
      final finalMessages = List<ChatMessage>.from(state.messages);
      finalMessages[finalMessages.length - 1] =
          finalMessages.last.copyWith(text: accumulatedText, isStreaming: false);
      emit(state.copyWith(
        messages: finalMessages,
        isGenerating: false,
      ));

      AppLogger.debug('🏁 AI Bloc: Stream completed');
    });
  }
}
