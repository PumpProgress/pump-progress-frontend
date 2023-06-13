part of 'exercise_bloc.dart';

enum ExerciseStatus { initial, loading, success }

const emptySets = <Series>[];

class ExerciseState extends Equatable {
  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.sets = emptySets,
    this.exerciseId = '',
  });

  final ExerciseStatus status;
  final List<Series> sets;
  final String exerciseId;

  @override
  List<Object> get props => [status, sets, exerciseId];

  ExerciseState copyWith({
    ExerciseStatus? status,
    List<Series>? sets,
    String? exerciseId,
  }) {
    return ExerciseState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }
}
