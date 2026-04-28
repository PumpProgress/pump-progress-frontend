// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'exercises_bloc.dart';

sealed class ExercisesStatus {
  const ExercisesStatus();
}

class ExercisesStatusLoading implements ExercisesStatus {
  const ExercisesStatusLoading();
}

class ExercisesStatusSuccess implements ExercisesStatus {
  const ExercisesStatusSuccess();
}

class ExercisesStatusError extends ErrorStatus implements ExercisesStatus {
  ExercisesStatusError(super.errorMsg);
}

class ExercisesState extends Equatable {
  const ExercisesState({
    this.status = const ExercisesStatusLoading(),
    this.exercises = const [],
  });

  final ExercisesStatus status;
  final List<Exercise> exercises;

  @override
  List<Object> get props => [status, exercises];

  ExercisesState copyWith({
    ExercisesStatus? status,
    List<Exercise>? exercises,
  }) {
    return ExercisesState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
    );
  }
}
