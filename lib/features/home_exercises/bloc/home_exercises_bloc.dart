import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';
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
      final exercises = HiveStorage.exerciseBox!.values;
      print("user" + me.toJson());

      final itemsFiltered =
          getFilteredExercises(event.searchValue, exercises, me);

      emit(
        state.copyWith(
          itemsFiltered: itemsFiltered,
          searchValue: event.searchValue,
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
      await HiveStorage.exerciseBox!.clear();
      final exercisesMap = <String, Exercise>{};
      final exercisesFiltered = <Exercise>[];

      for (var element in exercises) {
        if (me.favoriteExercises
            .any((favExerciseId) => favExerciseId == element.id)) {
          element = element.copyWith(isFavorite: true);
          exercisesFiltered.add(element);
        }
        exercisesMap[element.id] = element;
      }
      await HiveStorage.exerciseBox!.putAll(exercisesMap);

      emit(
        state.copyWith(
          status: HomeExerciseStatus.loaded,
          itemsFiltered: exercisesFiltered,
        ),
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
      final me = coreBloc.state.user;
      final oldExercise = state.itemsFiltered[event.index];
      final updatedExercise =
          oldExercise.copyWith(isFavorite: !oldExercise.isFavorite);

      final exerciseDB = HiveStorage.exerciseBox!.get(oldExercise.id);
      if (exerciseDB == null) {
        return;
      }
      await HiveStorage.exerciseBox!.put(
        exerciseDB.id,
        updatedExercise,
      );

      final exercises = HiveStorage.exerciseBox!.values;

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

      final itemsFiltered =
          getFilteredExercises(state.searchValue, exercises, meUpdated);

      coreBloc.add(CoreMeUpdated(me: meUpdated));
      emit(
        state.copyWith(
          itemsFiltered: itemsFiltered,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}

List<Exercise> getFilteredExercises(
  String searchValue,
  Iterable<Exercise> exercises,
  User me,
) {
  if (searchValue.isNotEmpty) {
    return exercises
        .where(
          (exercise) =>
              exercise.name.toLowerCase().contains(searchValue.toLowerCase()),
        )
        .toList();
  } else {
    return exercises
        .where(
          (exercise) => me.favoriteExercises
              .any((favExerciseId) => favExerciseId == exercise.id),
        )
        .toList();
  }
}
