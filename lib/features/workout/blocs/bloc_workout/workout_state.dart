part of 'workout_bloc.dart';

sealed class WorkoutsBlocStatus {
  const WorkoutsBlocStatus();
}

class WorkoutsBlocStatusLoading implements WorkoutsBlocStatus {
  const WorkoutsBlocStatusLoading();
}

class WorkoutsBlocStatusSuccess implements WorkoutsBlocStatus {
  const WorkoutsBlocStatusSuccess();
}

class WorkoutsBlocStatusError extends ErrorStatus
    implements WorkoutsBlocStatus {
  WorkoutsBlocStatusError(super.error);
}

class WorkoutState extends Equatable {
  const WorkoutState({
    this.workouts = const <Workout>[],
    this.status = const WorkoutsBlocStatusLoading(),
  });

  final List<Workout> workouts;
  final WorkoutsBlocStatus status;

  @override
  List<Object> get props => [workouts, status];

  WorkoutState copyWith({
    List<Workout>? workouts,
    WorkoutsBlocStatus? status,
  }) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
      status: status ?? this.status,
    );
  }
}
