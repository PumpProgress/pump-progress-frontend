part of 'exercise_analytics_bloc.dart';

sealed class ExerciseAnalyticsEvent extends Equatable {
  const ExerciseAnalyticsEvent();

  @override
  List<Object> get props => [];
}

class LoadExerciseAnalyticsEvent extends ExerciseAnalyticsEvent {
  final int exerciseId;
  final String userId;

  const LoadExerciseAnalyticsEvent({
    required this.exerciseId,
    required this.userId,
  });

  @override
  List<Object> get props => [exerciseId, userId];
}
