part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class FetchWorkoutEvent extends WorkoutEvent {
  const FetchWorkoutEvent({required this.userId});
  final String userId;
}

class AddWorkoutWorkoutEvent extends WorkoutEvent {
  const AddWorkoutWorkoutEvent({required this.name, required this.userId});
  final String name;
  final String userId;
}

class AddExerciseToWorkoutEvent extends WorkoutEvent {
  const AddExerciseToWorkoutEvent({
    required this.workoutId,
    required this.exerciseId,
    required this.userId,
  });

  final String workoutId;
  final int exerciseId;
  final String userId;

  @override
  List<Object> get props => [workoutId, exerciseId, userId];
}
