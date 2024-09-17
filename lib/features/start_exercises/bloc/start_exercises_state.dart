part of 'start_exercises_bloc.dart';

enum StartExerciseStatus { initial, loading, loaded, updatedUserFav }

const emptyExerciseList = <Exercise>[];

class StartExercisesState extends Equatable {
  const StartExercisesState({
    this.status = StartExerciseStatus.initial,
    this.itemsFiltered = emptyExerciseList,
    this.items = emptyExerciseList,
    this.searchValue = '',
    this.selectedMuscles = emptyList,
    this.selectedCategories = emptyList,
    this.showFilters = false,
  });

  final StartExerciseStatus status;
  final List<Exercise> itemsFiltered;
  final List<Exercise> items;
  final String searchValue;
  final List<String> selectedMuscles;
  final List<String> selectedCategories;
  final bool showFilters;

  @override
  List<Object> get props => [
        status,
        itemsFiltered,
        items,
        searchValue,
        selectedMuscles,
        selectedCategories,
        showFilters
      ];

  StartExercisesState copyWith({
    StartExerciseStatus? status,
    List<Exercise>? itemsFiltered,
    List<Exercise>? items,
    String? searchValue,
    List<String>? selectedMuscles,
    List<String>? selectedCategories,
    bool? showFilters,
  }) {
    return StartExercisesState(
        status: status ?? this.status,
        itemsFiltered: itemsFiltered ?? this.itemsFiltered,
        items: items ?? this.items,
        searchValue: searchValue ?? this.searchValue,
        selectedMuscles: selectedMuscles ?? this.selectedMuscles,
        selectedCategories: selectedCategories ?? this.selectedCategories,
        showFilters: showFilters ?? this.showFilters);
  }
}
