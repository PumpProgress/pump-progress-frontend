import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'home_exercises_event.dart';
part 'home_exercises_state.dart';

class HomeExercisesBloc extends Bloc<HomeExercisesEvent, HomeExercisesState> {
  HomeExercisesBloc({
    required this.pumpProgressRepository,
    required this.me,
  }) : super(const HomeExercisesState()) {
    on<UpdateExerciseListEvent>(_onUpdateExerciseListEvent);
    on<HardFetchExerciseListEvent>(_onHardFetchExerciseListEvent);
  }

  final PumpProgressRepository pumpProgressRepository;
  final User me;

  Future<void> _onUpdateExerciseListEvent(
    UpdateExerciseListEvent event,
    Emitter<HomeExercisesState> emit,
  ) async {
    try {
      // emit(state.copyWith(status: HomeExerciseStatus.loading));

      // final exercises = await pumpProgressRepository.getExercises();
      final exercises = HiveStorage.exerciseBox!.values;

      print(exercises.length);
      print('event.searchValue:' + event.searchValue + '|');
      print('event.searchValue.isNotEmpty ' +
          event.searchValue.isNotEmpty.toString());

      print("user" + me.toJson());

      var exercisesFiltered = <Exercise>[];

      if (event.searchValue.isNotEmpty) {
        exercisesFiltered = exercises
            .where(
              (exercise) => exercise.name
                  .toLowerCase()
                  .contains(event.searchValue.toLowerCase()),
            )
            .toList();
      } else {
        exercisesFiltered = exercises
            .where((exercise) => me.favoriteExercises
                .any((favExerciseId) => favExerciseId == exercise.id))
            .toList();
      }

      emit(
        state.copyWith(
          status: HomeExerciseStatus.loaded,
          items: exercises.toList(),
          itemsFiltered: exercisesFiltered,
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
      emit(state.copyWith(status: HomeExerciseStatus.loading));

      final exercises = await pumpProgressRepository.getExercises();
      await HiveStorage.exerciseBox!.clear();
      await HiveStorage.exerciseBox!.addAll(exercises);

      final exercisesFiltered = exercises
          .where((exercise) => me.favoriteExercises
              .any((favExerciseId) => favExerciseId == exercise.id))
          .toList();

      emit(
        state.copyWith(
          status: HomeExerciseStatus.loaded,
          items: exercises,
          itemsFiltered: exercisesFiltered,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
