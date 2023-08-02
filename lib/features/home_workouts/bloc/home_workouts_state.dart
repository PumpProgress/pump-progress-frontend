part of 'home_workouts_bloc.dart';

enum HomeWorkoutsStatus { initial, loading, success }

class HomeWorkoutsState extends Equatable {
  const HomeWorkoutsState({
    this.workouts = const <Workout>[],
    this.status = HomeWorkoutsStatus.initial,
  });

  final List<Workout> workouts;
  final HomeWorkoutsStatus status;

  @override
  List<Object> get props => [workouts, status];

  HomeWorkoutsState copyWith({
    List<Workout>? workouts,
    HomeWorkoutsStatus? status,
  }) {
    return HomeWorkoutsState(
      workouts: workouts ?? this.workouts,
      status: status ?? this.status,
    );
  }
}

class HomeWorkoutsInitial extends HomeWorkoutsState {}
