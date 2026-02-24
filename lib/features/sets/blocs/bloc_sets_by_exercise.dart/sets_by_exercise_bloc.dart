import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository_exercise.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'sets_by_exercise_event.dart';
part 'sets_by_exercise_state.dart';

class SetsByExerciseBloc
    extends Bloc<SetsByExerciseEvent, SetsByExerciseState> {
  final RepositorySets repositorySets;
  final RepositoryExercises repositoryExercises;

  SetsByExerciseBloc({
    required this.repositorySets,
    required this.repositoryExercises,
  }) : super(SetsByExerciseState()) {
    on<LoadSeriesByExerciseEvent>(_onLoadSeriesByExercise);
    on<AddNewSeriesEvent>(_onAddNewSeries);
    on<EditSeriesEvent>(_onEditSeries);
    on<DeleteSeriesEvent>(_onDeleteSeries);
  }
  Future<void> _onLoadSeriesByExercise(LoadSeriesByExerciseEvent event,
      Emitter<SetsByExerciseState> emit) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      emit(state.copyWith(status: SetsByExerciseStatusLoading()));
      final sets = await repositorySets.getSeriesByExercise(
          exerciseId: event.exerciseId, userId: event.userId);

      final exercise =
          await repositoryExercises.getExerciseById(event.exerciseId);
      emit(
        state.copyWith(
          status: SetsByExerciseStatusSuccess(),
          sets: sets,
          exercise: exercise,
        ),
      );
    });
  }

  Future<void> _onAddNewSeries(
      AddNewSeriesEvent event, Emitter<SetsByExerciseState> emit) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      final series = await repositorySets.createSeries(
        exerciseId: state.exercise.id,
        repetitions: event.repetitions,
        weight: event.weight,
        intensity: event.intensity,
        userId: event.userId,
      );
      final sets = List<Series>.from(state.sets);
      sets.insert(0, series);
      emit(state.copyWith(sets: sets));
    });
  }

  Future<void> _onEditSeries(
      EditSeriesEvent event, Emitter<SetsByExerciseState> emit) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      final updatedSeries = await repositorySets.updateSeries(
        seriesId: event.seriesId,
        repetitions: event.repetitions,
        weight: event.weight,
      );
      final sets = state.sets.map((series) {
        if (series.id == event.seriesId) {
          return updatedSeries;
        }
        return series;
      }).toList();
      emit(state.copyWith(sets: sets));
    });
  }

  Future<void> _onDeleteSeries(
      DeleteSeriesEvent event, Emitter<SetsByExerciseState> emit) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      await repositorySets.deleteSeries(seriesId: event.seriesId);
      final sets =
          state.sets.where((series) => series.id != event.seriesId).toList();
      emit(state.copyWith(sets: sets));
    });
  }
}
