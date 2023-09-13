part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadSeriesByExercise extends ExerciseEvent {
  const LoadSeriesByExercise(this.exerciseId);
  final String exerciseId;
}

class AddNewSeries extends ExerciseEvent {
  const AddNewSeries({
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
  });

  final String exerciseId;
  final int repetitions;
  final double weight;
}

class EditSeries extends ExerciseEvent {
  const EditSeries({
    required this.seriesId,
    required this.repetitions,
    required this.weight,
  });

  final String seriesId;
  final int repetitions;
  final double weight;
}
