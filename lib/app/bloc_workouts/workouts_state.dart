part of 'workouts_bloc.dart';

sealed class WorkoutsState extends Equatable {
  const WorkoutsState();
  
  @override
  List<Object> get props => [];
}

final class WorkoutsInitial extends WorkoutsState {}
