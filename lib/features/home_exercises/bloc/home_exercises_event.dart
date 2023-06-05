part of 'home_exercises_bloc.dart';

const emptyList = <String>[];

abstract class HomeExercisesEvent extends Equatable {
  const HomeExercisesEvent();

  @override
  List<Object> get props => [];
}

class UpdatedSearchExerciseListEvent extends HomeExercisesEvent {
  const UpdatedSearchExerciseListEvent({
    required this.searchValue,
    required this.selectedMuscles,
    required this.selectedCategories,
  });

  final String searchValue;
  final List<String> selectedMuscles;
  final List<String> selectedCategories;

  @override
  List<Object> get props => [searchValue, selectedMuscles, selectedCategories];
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
