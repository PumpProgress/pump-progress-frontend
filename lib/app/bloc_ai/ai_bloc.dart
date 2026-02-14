import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc() : super(AiState()) {
    on<AiInitEvent>(_onAiInitEvent);
    on<SendPromptEvent>(_onSendPromptEvent);
  }
  Future<void> _onAiInitEvent(AiInitEvent event, Emitter<AiState> emit) async {
    AppLogger.debug('Initializing AI Bloc: Installing model...');
    emit(state.copyWith(status: AiStatus.installing));

    await FlutterGemma.installModel(
      modelType: ModelType.gemmaIt,
    )
        .fromNetwork(
      'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
      token: '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',
    )
        .withProgress((progress) {
      AppLogger.debug('Downloading: ${progress}%');
    }).install();

    AppLogger.debug('AI Bloc initialized: Model installed successfully');
    emit(state.copyWith(status: AiStatus.loaded));
  }

  Future<void> _onSendPromptEvent(
      SendPromptEvent event, Emitter<AiState> emit) async {
    if (state.status != AiStatus.loaded) {
      AppLogger.debug(
          'AI Bloc: Cannot send prompt, model not loaded. Current status: ${state.status}');
      return;
    }

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
    StreamSubscription<ModelResponse>? streamSubscription;

    String _message = '';
    final responseStream = chat.generateChatResponseAsync();

    streamSubscription = responseStream.listen(
      (response) {
        if (response is String) {
          // _message = response as String;
          _message = "$_message$response";
        } else if (response is TextResponse) {
          _message = "$_message${response.token}";

          // DEBUG: Track text accumulation
          AppLogger.debug(
              '📝 GemmaInputField: Text accumulated: "${response.token}" -> total: "${_message}"');
        } else if (response is ThinkingResponse) {
          // print thinking content
          AppLogger.debug('💭 GemmaInputField: Thinking: ${response.content}');
        } else if (response is FunctionCallResponse) {
          AppLogger.debug(
              '🔧 GemmaInputField: Function call received: ${response.name}');
        }
      },
      onError: (error) {
        AppLogger.error('❌ GemmaInputField: Stream error: $error',
            error: error);
      },
      onDone: () {
        AppLogger.debug('🏁 GemmaInputField: Stream completed');
        streamSubscription?.cancel();
      },
    );
    // Cleanup
    // await chat.s
  }
}
