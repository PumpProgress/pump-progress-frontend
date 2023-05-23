part of 'home_exercises_bloc.dart';

enum HomeExerciseStatus { initial, loading, loaded, updatedUserFav }

const emptyExerciseList = <Exercise>[];

class HomeExercisesState extends Equatable {
  const HomeExercisesState({
    this.status = HomeExerciseStatus.initial,
    this.itemsFiltered = emptyExerciseList,
    this.searchValue = '',
  });

  final HomeExerciseStatus status;
  final List<Exercise> itemsFiltered;
  final String searchValue;

  @override
  List<Object> get props => [status, itemsFiltered];

  HomeExercisesState copyWith({
    HomeExerciseStatus? status,
    List<Exercise>? itemsFiltered,
    String? searchValue,
  }) {
    return HomeExercisesState(
      status: status ?? this.status,
      itemsFiltered: itemsFiltered ?? this.itemsFiltered,
      searchValue: searchValue ?? this.searchValue,
    );
  }
}
