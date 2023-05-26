part of 'exercise_bloc.dart';

enum ExerciseStatus { initial, loading, success }

const emptySets = <Series>[];

class ExerciseState extends Equatable {
  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.sets = emptySets,
  });

  final ExerciseStatus status;
  final List<Series> sets;

  @override
  List<Object> get props => [status, sets];

  ExerciseState copyWith({
    ExerciseStatus? status,
    List<Series>? sets,
  }) {
    return ExerciseState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
    );
  }
}
