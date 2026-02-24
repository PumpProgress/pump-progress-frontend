part of 'start_exercises_bloc.dart';

const emptyList = <String>[];

abstract class StartExercisesEvent extends Equatable {
  const StartExercisesEvent();

  @override
  List<Object> get props => [];
}

class UpdatedSearchExerciseListEvent extends StartExercisesEvent {
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

class HardFetchExerciseListEvent extends StartExercisesEvent {
  const HardFetchExerciseListEvent();
}

class HandleUpdateFavoriteExerciseEvent extends StartExercisesEvent {
  const HandleUpdateFavoriteExerciseEvent(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class HandleToggleFiltersEvent extends StartExercisesEvent {
  const HandleToggleFiltersEvent();

  @override
  List<Object> get props => [];
}
