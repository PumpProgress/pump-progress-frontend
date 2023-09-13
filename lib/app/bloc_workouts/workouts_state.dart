part of 'workouts_bloc.dart';

enum WorkoutsStatus { initial, loading, success }

class WorkoutsState extends Equatable {
  const WorkoutsState({
    this.workouts = const <Workout>[],
    this.status = WorkoutsStatus.initial,
  });

  final List<Workout> workouts;
  final WorkoutsStatus status;

  @override
  List<Object> get props => [workouts, status];

  WorkoutsState copyWith({
    List<Workout>? workouts,
    WorkoutsStatus? status,
  }) {
    return WorkoutsState(
      workouts: workouts ?? this.workouts,
      status: status ?? this.status,
    );
  }
}
