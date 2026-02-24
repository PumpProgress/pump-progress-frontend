part of 'sets_by_exercise_bloc.dart';

// final class SetsByExerciseInitial extends SetsByExerciseState {}

sealed class SetsByExerciseStatus {
  const SetsByExerciseStatus();
}

class SetsByExerciseStatusInitial implements SetsByExerciseStatus {
  const SetsByExerciseStatusInitial();
}

class SetsByExerciseStatusLoading implements SetsByExerciseStatus {
  const SetsByExerciseStatusLoading();
}

class SetsByExerciseStatusSuccess implements SetsByExerciseStatus {
  const SetsByExerciseStatusSuccess();
}

class ExercisePageStatusError extends ErrorStatus
    implements SetsByExerciseStatus {
  ExercisePageStatusError(super.errorMsg);
}

class SetsByExerciseState extends Equatable {
  const SetsByExerciseState({
    this.status = const SetsByExerciseStatusInitial(),
    this.sets = const <Series>[],
    this.exercise = const Exercise.empty(),
  });

  final SetsByExerciseStatus status;
  final Exercise exercise;
  final List<Series> sets;

  @override
  List<Object> get props => [status, sets, exercise];

  SetsByExerciseState copyWith({
    SetsByExerciseStatus? status,
    List<Series>? sets,
    Exercise? exercise,
  }) {
    return SetsByExerciseState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
      exercise: exercise ?? this.exercise,
    );
  }
}
