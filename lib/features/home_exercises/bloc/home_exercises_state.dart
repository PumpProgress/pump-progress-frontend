part of 'home_exercises_bloc.dart';

enum HomeExerciseStatus { initial, loading, loaded, updatedUserFav }

const emptyExerciseList = <Exercise>[];

class HomeExercisesState extends Equatable {
  const HomeExercisesState({
    this.status = HomeExerciseStatus.initial,
    this.itemsFiltered = emptyExerciseList,
    this.searchValue = '',
    this.selectedMuscles = emptyList,
    this.selectedCategories = emptyList,
  });

  final HomeExerciseStatus status;
  final List<Exercise> itemsFiltered;
  final String searchValue;
  final List<String> selectedMuscles;
  final List<String> selectedCategories;

  @override
  List<Object> get props => [
        status,
        itemsFiltered,
        searchValue,
        selectedMuscles,
        selectedCategories,
      ];

  HomeExercisesState copyWith({
    HomeExerciseStatus? status,
    List<Exercise>? itemsFiltered,
    String? searchValue,
    List<String>? selectedMuscles,
    List<String>? selectedCategories,
  }) {
    return HomeExercisesState(
      status: status ?? this.status,
      itemsFiltered: itemsFiltered ?? this.itemsFiltered,
      searchValue: searchValue ?? this.searchValue,
      selectedMuscles: selectedMuscles ?? this.selectedMuscles,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}
