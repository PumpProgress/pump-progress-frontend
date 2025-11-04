part of 'fllama_bloc.dart';

sealed class FllamaEvent extends Equatable {
  const FllamaEvent();

  @override
  List<Object> get props => [];
}

final class LoadFllamaEvent extends FllamaEvent {
  const LoadFllamaEvent();
}
