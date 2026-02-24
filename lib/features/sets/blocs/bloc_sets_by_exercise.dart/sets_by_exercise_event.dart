part of 'sets_by_exercise_bloc.dart';

abstract class SetsByExerciseEvent extends Equatable {
  const SetsByExerciseEvent();

  @override
  List<Object> get props => [];
}

class LoadSeriesByExerciseEvent extends SetsByExerciseEvent {
  const LoadSeriesByExerciseEvent({
    required this.exerciseId,
    required this.userId,
  });
  final int exerciseId;
  final String userId;
}

class AddNewSeriesEvent extends SetsByExerciseEvent {
  const AddNewSeriesEvent({
    required this.repetitions,
    required this.weight,
    this.intensity,
    required this.userId,
  });

  final int repetitions;
  final double weight;
  final int? intensity;
  final String userId;
}

class EditSeriesEvent extends SetsByExerciseEvent {
  const EditSeriesEvent({
    required this.seriesId,
    required this.repetitions,
    required this.weight,
    this.intensity,
  });

  final String seriesId;
  final int repetitions;
  final double weight;
  final int? intensity;
}

class DeleteSeriesEvent extends SetsByExerciseEvent {
  const DeleteSeriesEvent(this.seriesId);
  final String seriesId;
}
