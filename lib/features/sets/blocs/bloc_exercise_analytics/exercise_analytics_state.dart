part of 'exercise_analytics_bloc.dart';

sealed class ExerciseAnalyticsStatus {
  const ExerciseAnalyticsStatus();
}

class ExerciseAnalyticsStatusSuccess extends ExerciseAnalyticsStatus {
  const ExerciseAnalyticsStatusSuccess();
}

class ExerciseAnalyticsStatusLoading extends ExerciseAnalyticsStatus {
  const ExerciseAnalyticsStatusLoading();
}

class ExerciseAnalyticsStatusError extends ErrorStatus
    implements ExerciseAnalyticsStatus {
  ExerciseAnalyticsStatusError(super.error);
}

class ExerciseAnalyticsState extends Equatable {
  const ExerciseAnalyticsState({
    this.status = const ExerciseAnalyticsStatusSuccess(),
    this.data = const [],
  });

  final ExerciseAnalyticsStatus status;
  final List<ExerciseAnalytics> data;

  @override
  List<Object> get props => [status, data];

  ExerciseAnalyticsState copyWith({
    ExerciseAnalyticsStatus? status,
    List<ExerciseAnalytics>? data,
  }) {
    return ExerciseAnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
