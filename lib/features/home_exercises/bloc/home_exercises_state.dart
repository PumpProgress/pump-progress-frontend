part of 'home_exercises_bloc.dart';

enum HomeExerciseStatus { initial, loading, loaded }

const emptyExerciseList = <Exercise>[];

class HomeExercisesState extends Equatable {
  const HomeExercisesState({
    this.status = HomeExerciseStatus.initial,
    // this.items = emptyExerciseList,
    this.itemsFiltered = emptyExerciseList,
  });

  final HomeExerciseStatus status;

  // final List<Exercise> items;
  final List<Exercise> itemsFiltered;

  @override
  List<Object> get props => [status, itemsFiltered];

  HomeExercisesState copyWith({
    HomeExerciseStatus? status,
    List<Exercise>? items,
    List<Exercise>? itemsFiltered,
  }) {
    return HomeExercisesState(
      status: status ?? this.status,
      // items: items ?? this.items,
      itemsFiltered: itemsFiltered ?? this.itemsFiltered,
    );
  }
}
