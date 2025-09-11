part of 'workout_bloc.dart';

sealed class WorkoutPageStatus {
  const WorkoutPageStatus();
}

class WorkoutPageStatusInitial implements WorkoutPageStatus {
  const WorkoutPageStatusInitial();
}

class WorkoutPageStatusLoading implements WorkoutPageStatus {}

class WorkoutPageStatusSuccess implements WorkoutPageStatus {}

class WorkoutPageStatusError extends ErrorStatus implements WorkoutPageStatus {
  WorkoutPageStatusError(super.errorMsg);
}

class WorkoutState extends Equatable {
  const WorkoutState({
    this.workout = const Workout.empty(),
    this.status = const WorkoutPageStatusInitial(),
    this.searchValue = '',
    this.lastError,
    this.errorMsg = '',
  });

  final WorkoutPageStatus status;
  final Workout workout;
  final String searchValue;
  final DateTime? lastError;
  final String errorMsg;

  @override
  List<Object> get props => [status, workout, searchValue, errorMsg];

  WorkoutState copyWith({
    WorkoutPageStatus? status,
    Workout? workout,
    List<Exercise>? exercises,
    String? searchValue,
    DateTime? lastError,
    String? errorMsg,
  }) {
    return WorkoutState(
      status: status ?? this.status,
      workout: workout ?? this.workout,
      searchValue: searchValue ?? this.searchValue,
      lastError: lastError ?? this.lastError,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
