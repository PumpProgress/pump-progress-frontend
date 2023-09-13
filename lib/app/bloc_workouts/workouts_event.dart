part of 'workouts_bloc.dart';

abstract class WorkoutsEvent extends Equatable {
  const WorkoutsEvent();

  @override
  List<Object> get props => [];
}

class FetchWorkoutsEvent extends WorkoutsEvent {
  const FetchWorkoutsEvent();
}

class AddWorkoutWorkoutsEvent extends WorkoutsEvent {
  const AddWorkoutWorkoutsEvent({required this.name});
  final String name;
}

class AddExerciseToWorkoutEvent extends WorkoutsEvent {
  const AddExerciseToWorkoutEvent({
    required this.workoutId,
    required this.exerciseId,
  });

  final String workoutId;
  final String exerciseId;

  @override
  List<Object> get props => [];
}
