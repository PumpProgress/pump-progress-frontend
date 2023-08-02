part of 'home_workouts_bloc.dart';

abstract class HomeWorkoutsEvent extends Equatable {
  const HomeWorkoutsEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeWorkoutsEvent extends HomeWorkoutsEvent {
  const FetchHomeWorkoutsEvent();
}

class AddWorkoutHomeWorkoutsEvent extends HomeWorkoutsEvent {
  const AddWorkoutHomeWorkoutsEvent({required this.name});
  final String name;
}
