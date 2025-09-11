part of 'workouts_bloc.dart';

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

class WorkoutsState extends Equatable {
  const WorkoutsState({
    this.workouts = const <Workout>[],
    this.status = const WorkoutsBlocStatusLoading(),
  });

  final List<Workout> workouts;
  final WorkoutsBlocStatus status;

  @override
  List<Object> get props => [workouts, status];

  WorkoutsState copyWith({
    List<Workout>? workouts,
    WorkoutsBlocStatus? status,
  }) {
    return WorkoutsState(
      workouts: workouts ?? this.workouts,
      status: status ?? this.status,
    );
  }
}
