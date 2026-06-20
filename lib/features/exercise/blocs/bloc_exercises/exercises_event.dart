part of 'exercises_bloc.dart';

sealed class ExercisesEvent extends Equatable {
  const ExercisesEvent();

  @override
  List<Object> get props => [];
}

class FetchExercisesEvent extends ExercisesEvent {}
