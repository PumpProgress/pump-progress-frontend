part of 'gemma_model_bloc.dart';

sealed class GemmaModelEvent extends Equatable {
  const GemmaModelEvent();

  @override
  List<Object> get props => [];
}

class GemmaModelInitEvent extends GemmaModelEvent {
  const GemmaModelInitEvent();
}
