// lib/features/ai/blocs/bloc_gemma_model/gemma_model_event.dart
part of 'gemma_model_bloc.dart';

sealed class GemmaModelEvent extends Equatable {
  const GemmaModelEvent();

  @override
  List<Object> get props => [];
}

/// Restores the persisted selection (no download). Fired at startup and retry.
class GemmaModelInitEvent extends GemmaModelEvent {
  const GemmaModelInitEvent();
}

class _GemmaModelReadyEvent extends GemmaModelEvent {
  const _GemmaModelReadyEvent();
}

class _GemmaModelClearedEvent extends GemmaModelEvent {
  const _GemmaModelClearedEvent();
}
