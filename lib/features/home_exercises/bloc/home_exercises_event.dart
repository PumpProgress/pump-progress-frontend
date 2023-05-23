part of 'home_exercises_bloc.dart';

abstract class HomeExercisesEvent extends Equatable {
  const HomeExercisesEvent();

  @override
  List<Object> get props => [];
}

class UpdateExerciseListEvent extends HomeExercisesEvent {
  const UpdateExerciseListEvent(this.searchValue);

  final String searchValue;

  @override
  List<Object> get props => [searchValue];
}

class HardFetchExerciseListEvent extends HomeExercisesEvent {
  const HardFetchExerciseListEvent();
}
