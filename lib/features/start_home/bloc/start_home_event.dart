part of 'start_home_bloc.dart';

sealed class StartHomeEvent extends Equatable {
  const StartHomeEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialWorkoutSessions extends StartHomeEvent {}

class FetchNextWorkoutSessions extends StartHomeEvent {}
