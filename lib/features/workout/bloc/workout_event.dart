part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class InitWorkoutEvent extends WorkoutEvent {
  const InitWorkoutEvent({required this.workout});
  final Workout workout;
}

class LoadExercisesWorkoutEvent extends WorkoutEvent {
  const LoadExercisesWorkoutEvent();
}

class AddExerciseWorkoutEvent extends WorkoutEvent {
  const AddExerciseWorkoutEvent({required this.exerciseId});
  final String exerciseId;
}

class RemoveExerciseWorkoutEvent extends WorkoutEvent {
  const RemoveExerciseWorkoutEvent({required this.exerciseId});
  final String exerciseId;
}
