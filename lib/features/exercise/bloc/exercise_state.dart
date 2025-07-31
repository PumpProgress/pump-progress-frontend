part of 'exercise_bloc.dart';

enum ExerciseStatus { initial, loading, success }

class ExerciseState extends Equatable {
  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.sets = const <Series>[],
    this.exerciseId = '',
    this.exerciseName = '',
  });

  final ExerciseStatus status;
  final List<Series> sets;
  final String exerciseId;
  final String exerciseName;

  @override
  List<Object> get props => [status, sets, exerciseId];

  ExerciseState copyWith({
    ExerciseStatus? status,
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
