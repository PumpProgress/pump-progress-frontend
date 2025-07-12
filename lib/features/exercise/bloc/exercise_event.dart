part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadSeriesByExercise extends ExerciseEvent {
  const LoadSeriesByExercise({
    required this.exerciseId,
    required this.exerciseName,
  });
  final String exerciseId;
  final String exerciseName;
}

class AddNewSeries extends ExerciseEvent {
  const AddNewSeries({
    required this.repetitions,
    required this.weight,
  });

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

class DeleteSeries extends ExerciseEvent {
  const DeleteSeries(this.seriesId);
  final String seriesId;
}
