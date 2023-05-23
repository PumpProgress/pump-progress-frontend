part of 'home_exercises_bloc.dart';

abstract class HomeExercisesEvent extends Equatable {
  const HomeExercisesEvent();

  @override
  List<Object> get props => [];
}

class UpdatedSearchExerciseListEvent extends HomeExercisesEvent {
  const UpdatedSearchExerciseListEvent(this.searchValue);

  final String searchValue;

  @override
  List<Object> get props => [searchValue];
}

class HardFetchExerciseListEvent extends HomeExercisesEvent {
  const HardFetchExerciseListEvent();
}

class HandleUpdateFavoriteExerciseEvent extends HomeExercisesEvent {
  const HandleUpdateFavoriteExerciseEvent(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}
