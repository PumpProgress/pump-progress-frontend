// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'exercise_search_bloc.dart';

sealed class ExerciseSearchStatus {
  const ExerciseSearchStatus();
}

class ExerciseSearchSuccess extends ExerciseSearchStatus {
  const ExerciseSearchSuccess();
}

class ExerciseSearchLoading extends ExerciseSearchStatus {
  const ExerciseSearchLoading();
}

class ExerciseSearchError extends ErrorStatus implements ExerciseSearchStatus {
  ExerciseSearchError(super.errorMsg);
}

class ExerciseSearchState extends Equatable {
  const ExerciseSearchState({
    this.status = const ExerciseSearchSuccess(),
    this.exercises = const [],
  });

  final ExerciseSearchStatus status;
  final List<Exercise> exercises;

  @override
  List<Object> get props => [status, exercises];

  ExerciseSearchState copyWith({
    ExerciseSearchStatus? status,
    List<Exercise>? exercises,
  }) {
    return ExerciseSearchState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
    );
  }
}
