import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'start_exercises_event.dart';
part 'start_exercises_state.dart';

@Deprecated(
    'This bloc is not used anymore, pumpProgressRepository is migrated into features')
class StartExercisesBloc
    extends Bloc<StartExercisesEvent, StartExercisesState> {
  // final PumpProgressRepository pumpProgressRepository;
  final User me;

  StartExercisesBloc({
    // required this.pumpProgressRepository,
    required this.me,
  }) : super(const StartExercisesState()) {
    on<UpdatedSearchExerciseListEvent>(_onUpdatedSearchExerciseListEvent);
    on<HardFetchExerciseListEvent>(_onHardFetchExerciseListEvent);
    on<HandleUpdateFavoriteExerciseEvent>(_onHandleUpdateFavoriteExerciseEvent);
    on<HandleToggleFiltersEvent>(_onHandleToggleFiltersEvent);
  }

  Future<void> _onUpdatedSearchExerciseListEvent(
    UpdatedSearchExerciseListEvent event,
    Emitter<StartExercisesState> emit,
  ) async {
    try {
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
    Emitter<StartExercisesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: StartExerciseStatus.loading));

      // final exercises = await pumpProgressRepository.getExercises();

      // final exercisesFiltered = <Exercise>[];
      // final items = <Exercise>[];

      // for (var element in exercises) {
      //   if (me.favoriteExercises
      //       .any((favExerciseId) => favExerciseId == element.id)) {
      //     element = element.copyWith(isFavorite: true);
      //     exercisesFiltered.add(element);
      //   }
      //   items.add(element);
      // }

      // emit(
      //   state.copyWith(
      //       status: StartExerciseStatus.loaded,
      //       itemsFiltered: exercisesFiltered,
      //       items: items),
      // );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onHandleUpdateFavoriteExerciseEvent(
    HandleUpdateFavoriteExerciseEvent event,
    Emitter<StartExercisesState> emit,
  ) async {
    try {
      // final oldExercise = state.itemsFiltered[event.index];
      // final itemsIndex =
      //     state.items.indexWhere((element) => element.name == oldExercise.name);
      // final updatedExercise =
      //     oldExercise.copyWith(isFavorite: !oldExercise.isFavorite);

      // state.items[itemsIndex] = updatedExercise;

      // User meUpdated;
      // if (updatedExercise.isFavorite) {
      //   meUpdated = await pumpProgressRepository.postUSerAddFavoriteExercise(
      //     exerciseId: updatedExercise.id,
      //     userId: me.id,
      //   );
      // } else {
      //   meUpdated = await pumpProgressRepository.postUserRemoveFavoriteExercise(
      //     exerciseId: updatedExercise.id,
      //     userId: me.id,
      //   );
      // }

      // final itemsFiltered = getFilteredExercises(
      //   state.searchValue,
      //   state.selectedMuscles,
      //   state.selectedCategories,
      //   state.items,
      //   meUpdated,
      // );

      // // coreBloc.add(CoreMeUpdated(me: meUpdated));
      // emit(
      //   state.copyWith(
      //       itemsFiltered: itemsFiltered,
      //       items: state.items,
      //       status: StartExerciseStatus.updatedUserFav),
      // );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onHandleToggleFiltersEvent(
    HandleToggleFiltersEvent event,
    Emitter<StartExercisesState> emit,
  ) async {
    try {
      // emit(
      //   state.copyWith(showFilters: !state.showFilters),
      // );
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
