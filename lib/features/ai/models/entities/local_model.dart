// lib/features/ai/models/entities/local_model.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

/// A pre-defined, code-configured on-device model the user can download.
/// [id] is the model filename (basename of [url]); flutter_gemma uses it for
/// isModelInstalled / uninstallModel.
class LocalModel extends Equatable {
  const LocalModel({
    required this.id,
    required this.displayName,
    required this.description,
    required this.url,
    required this.modelType,
    required this.fileType,
    required this.maxTokens,
    required this.sizeBytes,
  });

  final String id;
  final String displayName;
  final String description;
  final String url;
  final ModelType modelType;
  final ModelFileType fileType;
  final int maxTokens;

  /// Manually-set per-model disk footprint, in bytes. Shown in the row.
  /// (flutter_gemma does not expose exact per-model on-disk size publicly.)
  final int sizeBytes;

  @override
  List<Object> get props =>
      [id, displayName, description, url, modelType, fileType, maxTokens, sizeBytes];
}
