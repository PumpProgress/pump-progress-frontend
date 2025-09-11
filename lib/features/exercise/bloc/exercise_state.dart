part of 'exercise_bloc.dart';

sealed class ExercisePageStatus {
  const ExercisePageStatus();
}

class ExercisePageStatusInitial implements ExercisePageStatus {
  const ExercisePageStatusInitial();
}

class ExercisePageStatusLoading implements ExercisePageStatus {
  const ExercisePageStatusLoading();
}

class ExercisePageStatusSuccess implements ExercisePageStatus {
  const ExercisePageStatusSuccess();
}

class ExercisePageStatusError extends ErrorStatus
    implements ExercisePageStatus {
  ExercisePageStatusError(super.errorMsg);
}

class ExerciseState extends Equatable {
  const ExerciseState({
    this.status = const ExercisePageStatusInitial(),
    this.sets = const <Series>[],
    this.exerciseId = '',
    this.exerciseName = '',
  });

  final ExercisePageStatus status;
  final List<Series> sets;
  final String exerciseId;
  final String exerciseName;

  @override
  List<Object> get props => [status, sets, exerciseId];

  ExerciseState copyWith({
    ExercisePageStatus? status,
    List<Series>? sets,
    String? exerciseId,
    String? exerciseName,
  }) {
    return ExerciseState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
    );
  }
}
