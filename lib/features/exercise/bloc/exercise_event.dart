part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadSeriesByExercise extends ExerciseEvent {
  const LoadSeriesByExercise(this.exerciseId);
  final String exerciseId;
}
