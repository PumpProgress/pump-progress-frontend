part of 'start_home_bloc.dart';

enum StartHomeStatus { success, loading, error }

class StartHomeState extends Equatable {
  const StartHomeState({
    this.workoutSessions = const <WorkoutSession>[],
    this.status = StartHomeStatus.loading,
    this.areMore = true,
  });

  final StartHomeStatus status;
  final List<WorkoutSession> workoutSessions;
  final bool areMore;

  @override
  List<Object> get props => [status, workoutSessions, areMore];

  StartHomeState copyWith({
    List<WorkoutSession>? workoutSessions,
    StartHomeStatus? status,
    bool? areMore,
  }) {
    return StartHomeState(
      workoutSessions: workoutSessions ?? this.workoutSessions,
      status: status ?? this.status,
      areMore: areMore ?? this.areMore,
    );
  }
}
