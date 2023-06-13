import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'home_exercises_event.dart';
part 'home_exercises_state.dart';

class HomeExercisesBloc extends Bloc<HomeExercisesEvent, HomeExercisesState> {
  HomeExercisesBloc({
    required this.pumpProgressRepository,
    // required this.me,s
    required this.coreBloc,
  }) : super(const HomeExercisesState()) {
    on<UpdatedSearchExerciseListEvent>(_onUpdatedSearchExerciseListEvent);
    on<HardFetchExerciseListEvent>(_onHardFetchExerciseListEvent);
    on<HandleUpdateFavoriteExerciseEvent>(_onHandleUpdateFavoriteExerciseEvent);
  }

  final PumpProgressRepository pumpProgressRepository;
  // final User me;
  final CoreBloc coreBloc;

  Future<void> _onUpdatedSearchExerciseListEvent(
    UpdatedSearchExerciseListEvent event,
    Emitter<HomeExercisesState> emit,
  ) async {
    try {
      final me = coreBloc.state.user;

      final itemsFiltered = getFilteredExercises(
        event.searchValue,
        event.selectedMuscles,
        event.selectedCategories,
        state.items,
        me,
      );

      emit(
        state.copyWith(
          itemsFiltered: itemsFiltered,
          searchValue: event.searchValue,
          selectedMuscles: event.selectedMuscles,
          selectedCategories: event.selectedCategories,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onHardFetchExerciseListEvent(
    HardFetchExerciseListEvent event,
    Emitter<HomeExercisesState> emit,
  ) async {
    try {
      final me = coreBloc.state.user;
      emit(state.copyWith(status: HomeExerciseStatus.loading));

      final exercises = await pumpProgressRepository.getExercises();

      final exercisesFiltered = <Exercise>[];
      final items = <Exercise>[];

      for (var element in exercises) {
        if (me.favoriteExercises
            .any((favExerciseId) => favExerciseId == element.id)) {
          element = element.copyWith(isFavorite: true);
          exercisesFiltered.add(element);
        }
        items.add(element);
      }

      emit(
        state.copyWith(
            status: HomeExerciseStatus.loaded,
            itemsFiltered: exercisesFiltered,
            items: items),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onHandleUpdateFavoriteExerciseEvent(
    HandleUpdateFavoriteExerciseEvent event,
    Emitter<HomeExercisesState> emit,
  ) async {
    try {
      final oldExercise = state.itemsFiltered[event.index];
      final itemsIndex =
          state.items.indexWhere((element) => element.name == oldExercise.name);
      final updatedExercise =
          oldExercise.copyWith(isFavorite: !oldExercise.isFavorite);

      state.items[itemsIndex] = updatedExercise;

      User meUpdated;
      if (updatedExercise.isFavorite) {
        meUpdated = await pumpProgressRepository.postAddFavoriteExercise(
          exerciseId: updatedExercise.id,
        );
      } else {
        meUpdated = await pumpProgressRepository.postRemoveFavoriteExercise(
          exerciseId: updatedExercise.id,
        );
      }

      final itemsFiltered = getFilteredExercises(
        state.searchValue,
        state.selectedMuscles,
        state.selectedCategories,
        state.items,
        meUpdated,
      );

      coreBloc.add(CoreMeUpdated(me: meUpdated));
      emit(
        state.copyWith(itemsFiltered: itemsFiltered, items: state.items),
      );
    } catch (e) {
      print(e);
    }
  }
}

List<Exercise> exercisesFilteredByFilters(
  Iterable<Exercise> exercises,
  List<String> selectedMuscles,
  List<String> selectedCategories,
) {
  var response = exercises;
  if (selectedMuscles.isNotEmpty) {
    response = response.where(
      (exercise) =>
          exercise.muscles.any((muscle) => selectedMuscles.contains(muscle)),
    );
  }
  if (selectedCategories.isNotEmpty) {
    response = response
        .where((exercise) => selectedCategories.contains(exercise.category));
  }

  return response.toList();
}

List<Exercise> getFilteredExercises(
  String searchValue,
  List<String> selectedMuscles,
  List<String> selectedCategories,
  Iterable<Exercise> exercises,
  User me,
) {
  final filteredExercises = exercisesFilteredByFilters(
    exercises,
    selectedMuscles,
    selectedCategories,
  );
  final favoriteExercises = filteredExercises
      .where(
        (exercise) => me.favoriteExercises
            .any((favExerciseId) => favExerciseId == exercise.id),
      )
      .toList();

  if (searchValue.isEmpty && favoriteExercises.isEmpty) {
    return filteredExercises;
  } else if (searchValue.isEmpty) {
    return favoriteExercises;
  } else {
    return filteredExercises
        .where(
          (exercise) =>
              exercise.name.toLowerCase().contains(searchValue.toLowerCase()),
        )
        .toList();
  }
}
