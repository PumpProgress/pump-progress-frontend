// lib/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'gemma_model_event.dart';
part 'gemma_model_state.dart';

/// Gates the chat UI on whether an active on-device model exists.
class GemmaModelBloc extends Bloc<GemmaModelEvent, GemmaModelState> {
  GemmaModelBloc({required GemmaModelService modelService})
      : _modelService = modelService,
        super(const GemmaModelState()) {
    on<GemmaModelInitEvent>(_onInit);
    on<_GemmaModelReadyEvent>(_onReady);
    on<_GemmaModelClearedEvent>(_onCleared);

    _modelSub = _modelService.modelStream
        .listen((_) => add(const _GemmaModelReadyEvent()));
    _clearedSub = _modelService.clearedStream
        .listen((_) => add(const _GemmaModelClearedEvent()));
  }

  final GemmaModelService _modelService;
  StreamSubscription<dynamic>? _modelSub;
  StreamSubscription<void>? _clearedSub;

  Future<void> _onInit(
    GemmaModelInitEvent event,
    Emitter<GemmaModelState> emit,
  ) async {
    try {
      emit(state.copyWith(status: const GemmaModelStatusLoading()));
      await _modelService.restoreActive();
      emit(state.copyWith(
        status: _modelService.hasActiveModel
            ? const GemmaModelStatusReady()
            : const GemmaModelStatusNoModel(),
      ));
    } catch (e) {
      emit(state.copyWith(status: GemmaModelStatusError(e.toString())));
    }
  }

  void _onReady(_GemmaModelReadyEvent event, Emitter<GemmaModelState> emit) {
    emit(state.copyWith(status: const GemmaModelStatusReady()));
  }

  void _onCleared(
    _GemmaModelClearedEvent event,
    Emitter<GemmaModelState> emit,
  ) {
    emit(state.copyWith(status: const GemmaModelStatusNoModel()));
  }

  @override
  Future<void> close() {
    _modelSub?.cancel();
    _clearedSub?.cancel();
    return super.close();
  }
}
