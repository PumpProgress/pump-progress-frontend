import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
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
  AiBloc() : super(AiState()) {
    on<AiInitEvent>(_onAiInitEvent);
    on<SendPromptEvent>(_onSendPromptEvent);
  }

  InferenceChat? _chat;

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

      final model = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.gpu,
      );
      _chat = await model.createChat();

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

      await for (final response in _chat!.generateChatResponseAsync()) {
        if (response is! TextResponse) continue;
        final token = response.token;
        if (token.isEmpty) continue;
        rawAccumulated += token;
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] =
            updatedMessages.last.copyWith(text: _decodeEscapes(rawAccumulated));
        emit(state.copyWith(messages: updatedMessages));
      }

      final finalMessages = List<ChatMessage>.from(state.messages);
      finalMessages[finalMessages.length - 1] = finalMessages.last
          .copyWith(text: _decodeEscapes(rawAccumulated), isStreaming: false);
      emit(state.copyWith(
        messages: finalMessages,
        isGenerating: false,
      ));

      AppLogger.debug('AI Bloc: Stream completed');
    });
  }
}
