part of 'workout_bloc.dart';

enum WorkoutPageStatus { initial, loading, success }

class WorkoutState extends Equatable {
  const WorkoutState({
    this.workout = const Workout.empty(),
    this.status = WorkoutPageStatus.initial,
    this.workoutExercises = const [],
    this.exercises = const [],
    this.searchValue = '',
  });

  final WorkoutPageStatus status;
  final Workout workout;
  final List<Exercise> workoutExercises;
  final List<Exercise> exercises;
  final String searchValue;

  @override
  List<Object> get props => [
        status,
        workout,
        workoutExercises,
        exercises,
        searchValue,
      ];

  WorkoutState copyWith({
    WorkoutPageStatus? status,
    Workout? workout,
    List<Exercise>? workoutExercises,
    List<Exercise>? exercises,
    String? searchValue,
  }) {
    return WorkoutState(
      status: status ?? this.status,
      workout: workout ?? this.workout,
      workoutExercises: workoutExercises ?? this.workoutExercises,
      exercises: exercises ?? this.exercises,
      searchValue: searchValue ?? this.searchValue,
    );
  }
}
