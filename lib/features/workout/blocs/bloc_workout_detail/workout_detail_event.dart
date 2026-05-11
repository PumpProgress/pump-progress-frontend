part of 'workout_detail_bloc.dart';

sealed class WorkoutDetailEvent extends Equatable {
  const WorkoutDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkoutDetailEvent extends WorkoutDetailEvent {
  const LoadWorkoutDetailEvent({required this.workoutId});
  final String workoutId;
}

class AddExerciseWorkoutDetailEvent extends WorkoutDetailEvent {
  const AddExerciseWorkoutDetailEvent({required this.exerciseId});
  final int exerciseId;
}

class RemoveExerciseWorkoutDetailEvent extends WorkoutDetailEvent {
  const RemoveExerciseWorkoutDetailEvent({required this.exerciseId});
  final int exerciseId;
}

class UpdateSearchValueWorkoutDetailEvent extends WorkoutDetailEvent {
  const UpdateSearchValueWorkoutDetailEvent({required this.searchValue});
  final String searchValue;
}

class RenameWorkoutDetailEvent extends WorkoutDetailEvent {
  const RenameWorkoutDetailEvent({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

class DeleteWorkoutDetailEvent extends WorkoutDetailEvent {}
