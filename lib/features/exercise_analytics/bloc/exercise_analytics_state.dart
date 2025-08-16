part of 'exercise_analytics_bloc.dart';

enum ExerciseAnalyticsStatus { loading, success, failure }

class ExerciseAnalyticsState extends Equatable {
  const ExerciseAnalyticsState({
    this.status = ExerciseAnalyticsStatus.loading,
    this.data = const [],
    this.exerciseId = '',
    this.exerciseName = '',
    this.lastError,
  });

  final ExerciseAnalyticsStatus status;
  final DateTime? lastError;
  final List<ExerciseAnalytics> data;
  final String exerciseId;
  final String exerciseName;

  ExerciseAnalyticsState copyWith({
    ExerciseAnalyticsStatus? status,
    List<ExerciseAnalytics>? data,
    String? exerciseId,
    String? exerciseName,
    DateTime? lastError,
  }) {
    return ExerciseAnalyticsState(
        status: status ?? this.status,
        data: data ?? this.data,
        exerciseId: exerciseId ?? this.exerciseId,
        exerciseName: exerciseName ?? this.exerciseName,
        lastError: lastError ?? this.lastError);
  }

  @override
  List<Object> get props => [status, data, exerciseId, exerciseName];
}

final class ExerciseAnalyticsInitial extends ExerciseAnalyticsState {}
