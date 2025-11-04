part of 'fllama_bloc.dart';

sealed class FllamaState extends Equatable {
  const FllamaState();
  
  @override
  List<Object> get props => [];
}

final class FllamaInitial extends FllamaState {}
