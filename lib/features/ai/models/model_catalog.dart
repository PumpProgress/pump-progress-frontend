// lib/features/ai/models/model_catalog.dart
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/features/ai/models/entities/local_model.dart';

/// Code-defined set of downloadable on-device models.
/// Add a model = add an entry here.
const kModelCatalog = <LocalModel>[
  LocalModel(
    id: 'gemma-4-E2B-it.litertlm',
    displayName: 'Gemma 4 E2B',
    description: 'Compact on-device model. Good default.',
    url:
        'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm',
    modelType: ModelType.gemma4,
    fileType: ModelFileType.litertlm,
    maxTokens: 2048,
    sizeBytes: 3 * 1024 * 1024 * 1024, // ~3 GB — set manually per model
  ),
];
