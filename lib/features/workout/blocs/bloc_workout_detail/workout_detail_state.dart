part of 'workout_detail_bloc.dart';

sealed class WorkoutDetailStatus {
  const WorkoutDetailStatus();
}

class WorkoutDetailStatusInitial implements WorkoutDetailStatus {
  const WorkoutDetailStatusInitial();
}

class WorkoutDetailStatusLoading implements WorkoutDetailStatus {}

class WorkoutDetailStatusSuccess implements WorkoutDetailStatus {}

class WorkoutDetailStatusError extends ErrorStatus
    implements WorkoutDetailStatus {
  WorkoutDetailStatusError(super.errorMsg);
}

class WorkoutDetailStatusUpdated implements WorkoutDetailStatus {}

class WorkoutDetailStatusDeleted implements WorkoutDetailStatus {}

class WorkoutDetailState extends Equatable {
  const WorkoutDetailState({
    this.workout = const Workout.empty(),
    this.status = const WorkoutDetailStatusInitial(),
    this.searchValue = '',
  });

  final WorkoutDetailStatus status;
  final Workout workout;
  final String searchValue;

  @override
  List<Object> get props => [status, workout];

  WorkoutDetailState copyWith({
    WorkoutDetailStatus? status,
    Workout? workout,
    List<Exercise>? exercises,
    String? searchValue,
    DateTime? lastError,
    String? errorMsg,
  }) {
    return WorkoutDetailState(
      status: status ?? this.status,
      workout: workout ?? this.workout,
      searchValue: searchValue ?? this.searchValue,
    );
  }
}
