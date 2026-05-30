// lib/features/ai/services/gemma_model_service.dart
import 'dart:async';

import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/ai/models/entities/local_model.dart';
import 'package:pump_progress_frontend/features/ai/models/model_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns all flutter_gemma model-management calls plus persistence of the
/// user's selected (active) model. One inference model is active at a time.
class GemmaModelService {
  final StreamController<InferenceModel> _modelController =
      StreamController<InferenceModel>.broadcast();
  final StreamController<void> _clearedController =
      StreamController<void>.broadcast();

  InferenceModel? _model;
  String? _activeId;
  bool _busy = false;

  /// Emits whenever a model becomes active (download or select).
  Stream<InferenceModel> get modelStream => _modelController.stream;

  /// Emits when the active model is removed (deleted).
  Stream<void> get clearedStream => _clearedController.stream;

  InferenceModel? get model => _model;
  String? get activeId => _activeId;
  bool get hasActiveModel => _model != null;

  /// Downloads [m] if needed (install() skips download when already present)
  /// and sets it active, then loads it as the runtime model.
  Future<void> activate(
    LocalModel m, {
    void Function(int progress)? onProgress,
  }) async {
    if (_busy) return;
    _busy = true;
    try {
      await FlutterGemma.installModel(
        modelType: m.modelType,
        fileType: m.fileType,
      )
          .fromNetwork(m.url)
          .withProgress((progress) => onProgress?.call(progress))
          .install();

      _model = await FlutterGemma.getActiveModel(
        maxTokens: m.maxTokens,
        preferredBackend: PreferredBackend.gpu,
      );
      _activeId = m.id;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(selectedAiModelKey, m.id);

      _modelController.add(_model!);
    } finally {
      _busy = false;
    }
  }

  /// Removes [m] from disk. If it was active, clears the active model.
  Future<void> delete(LocalModel m) async {
    await FlutterGemma.uninstallModel(m.id);
    if (_activeId == m.id) {
      _model = null;
      _activeId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(selectedAiModelKey);
      _clearedController.add(null);
    }
  }

  /// Re-applies the persisted selection on startup. No download occurs if the
  /// model is missing — the selection is cleared instead.
  Future<void> restoreActive() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(selectedAiModelKey);
    if (id == null) return;

    LocalModel? match;
    for (final m in kModelCatalog) {
      if (m.id == id) {
        match = m;
        break;
      }
    }
    if (match == null) {
      await prefs.remove(selectedAiModelKey);
      return;
    }
    if (!await FlutterGemma.isModelInstalled(id)) {
      await prefs.remove(selectedAiModelKey);
      return;
    }
    await activate(match);
  }

  /// Catalog ids currently installed on disk.
  Future<Set<String>> installedIds() async {
    final installed = await FlutterGemma.listInstalledModels();
    final catalogIds = kModelCatalog.map((m) => m.id).toSet();
    return installed.toSet().intersection(catalogIds);
  }

  /// Combined on-disk usage of all installed models, in bytes.
  /// Per-model size is not exposed by the public API; only the total is.
  Future<int> totalDiskBytes() async {
    try {
      final stats =
          await FlutterGemmaPlugin.instance.modelManager.getStorageStats();
      return stats['totalSizeBytes'] ?? 0;
    } catch (_) {
      return 0;
    }
  }

  void dispose() {
    _modelController.close();
    _clearedController.close();
  }
}
