import 'dart:async';

import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaModelService {
  final StreamController<InferenceModel> _controller =
      StreamController<InferenceModel>.broadcast();

  InferenceModel? _model;
  bool _initializing = false;

  /// Emits once when the model becomes ready. Subscribers that join after
  /// the model is already ready should check [isReady] and read [model] directly.
  Stream<InferenceModel> get modelStream => _controller.stream;

  InferenceModel? get model => _model;
  bool get isReady => _model != null;

  Future<void> initialize({void Function(int progress)? onProgress}) async {
    if (isReady || _initializing) return;
    _initializing = true;
    try {
      await FlutterGemma.installModel(
        modelType: ModelType.gemma4,
        fileType: ModelFileType.litertlm,
      )
          .fromNetwork(
        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm',
      )
          .withProgress((progress) => onProgress?.call(progress))
          .install();

      _model = await FlutterGemma.getActiveModel(
        maxTokens: 2048,
        preferredBackend: PreferredBackend.gpu,
      );
      _controller.add(_model!);
    } finally {
      _initializing = false;
    }
  }

  void dispose() {
    _controller.close();
  }
}
