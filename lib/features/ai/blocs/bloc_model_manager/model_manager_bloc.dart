// lib/features/ai/blocs/bloc_model_manager/model_manager_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/ai/models/entities/local_model.dart';
import 'package:pump_progress_frontend/features/ai/models/model_catalog.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';

part 'model_manager_event.dart';
part 'model_manager_state.dart';

/// Drives the Models page: list catalog state, download, select, delete.
class ModelManagerBloc extends Bloc<ModelManagerEvent, ModelManagerState> {
  ModelManagerBloc({required GemmaModelService service})
      : _service = service,
        super(const ModelManagerState()) {
    on<LoadModels>(_onLoad);
    on<DownloadModel>(_onDownload);
    on<SelectModel>(_onSelect);
    on<DeleteModel>(_onDelete);
  }

  final GemmaModelService _service;

  /// Guards against overlapping activations (download/select). The underlying
  /// service silently no-ops concurrent activations, which would otherwise let
  /// a second handler emit a false "downloaded" success.
  bool _activating = false;

  Future<void> _onLoad(LoadModels event, Emitter<ModelManagerState> emit) async {
    try {
      final installed = await _service.installedIds();
      final total = await _service.totalDiskBytes();
      final items = kModelCatalog.map((m) {
        final isInstalled = installed.contains(m.id);
        return ModelItem(
          model: m,
          state: isInstalled
              ? ModelDownloadState.downloaded
              : ModelDownloadState.notDownloaded,
          progress: isInstalled ? 100 : 0,
          isActive: _service.activeId == m.id,
        );
      }).toList();
      emit(ModelManagerState(items: items, totalDiskBytes: total));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDownload(
    DownloadModel event,
    Emitter<ModelManagerState> emit,
  ) async {
    if (_activating) return;
    _activating = true;
    _patch(emit, event.model.id,
        (i) => i.copyWith(state: ModelDownloadState.downloading, progress: 0));
    try {
      await _service.activate(
        event.model,
        onProgress: (p) =>
            _patch(emit, event.model.id, (i) => i.copyWith(progress: p)),
      );
      final total = await _service.totalDiskBytes();
      emit(state.copyWith(
        items: state.items
            .map((i) => i.model.id == event.model.id
                ? i.copyWith(
                    state: ModelDownloadState.downloaded,
                    progress: 100,
                    isActive: true)
                : i.copyWith(isActive: false))
            .toList(),
        totalDiskBytes: total,
      ));
    } catch (e) {
      _patch(emit, event.model.id,
          (i) => i.copyWith(state: ModelDownloadState.notDownloaded, progress: 0));
      emit(state.copyWith(error: e.toString()));
    } finally {
      _activating = false;
    }
  }

  Future<void> _onSelect(
    SelectModel event,
    Emitter<ModelManagerState> emit,
  ) async {
    if (_activating) return;
    _activating = true;
    try {
      await _service.activate(event.model);
      emit(state.copyWith(
        items: state.items
            .map((i) => i.copyWith(isActive: i.model.id == event.model.id))
            .toList(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      _activating = false;
    }
  }

  Future<void> _onDelete(
    DeleteModel event,
    Emitter<ModelManagerState> emit,
  ) async {
    try {
      await _service.delete(event.model);
      final total = await _service.totalDiskBytes();
      emit(state.copyWith(
        items: state.items
            .map((i) => i.model.id == event.model.id
                ? i.copyWith(
                    state: ModelDownloadState.notDownloaded,
                    progress: 0,
                    isActive: false)
                : i)
            .toList(),
        totalDiskBytes: total,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _patch(
    Emitter<ModelManagerState> emit,
    String id,
    ModelItem Function(ModelItem) update,
  ) {
    emit(state.copyWith(
      items: state.items.map((i) => i.model.id == id ? update(i) : i).toList(),
    ));
  }
}
