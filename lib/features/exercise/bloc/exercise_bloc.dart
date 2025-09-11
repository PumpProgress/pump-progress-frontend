import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';
import 'package:pump_progress_frontend/utils/services/native_service/timer_service.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc({required this.pumpProgressRepository, required this.coreState})
      : super(const ExerciseState()) {
    on<LoadSeriesByExercise>(_onLoadSeriesByExercise);
    on<AddNewSeries>(_onAddNewSeries);
    on<EditSeries>(_onEditSeries);
  }

  final PumpProgressRepository pumpProgressRepository;
  final CoreState coreState;

  Future<void> _onLoadSeriesByExercise(
    LoadSeriesByExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      emit(state.copyWith(status: ExercisePageStatusLoading()));
      final sets = await pumpProgressRepository.getSets(
          exerciseId: event.exerciseId, userId: coreState.user.id);
      emit(
        state.copyWith(
          status: ExercisePageStatusSuccess(),
          sets: sets,
          exerciseId: event.exerciseId,
          exerciseName: event.exerciseName,
        ),
      );
    });
  }

  Future<void> _onAddNewSeries(
    AddNewSeries event,
    Emitter<ExerciseState> emit,
  ) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      final series = await pumpProgressRepository.postSeries(
        exerciseId: state.exerciseId,
        repetitions: event.repetitions,
        weight: event.weight,
      );
      await TimerService.startTimer(
        lastSetTime: DateTime.now(),
        exerciseName: state.exerciseName,
        weight: event.weight,
        reps: event.repetitions,
      );
      final sets = List<Series>.from(state.sets);
      sets.insert(0, series);

      emit(state.copyWith(sets: sets));
    });
  }

  Future<void> _onEditSeries(
    EditSeries event,
    Emitter<ExerciseState> emit,
  ) async {
    await runSafeEvent(emit, state, ExercisePageStatusError.new, () async {
      final series = await pumpProgressRepository.putSeries(
        seriesId: event.seriesId,
        repetitions: event.repetitions,
        weight: event.weight,
      );
      final sets = List<Series>.from(state.sets);
      final seriesAtListIndex =
          sets.indexWhere((series) => series.id == event.seriesId);
      sets[seriesAtListIndex] = series;

      emit(state.copyWith(sets: sets));
    });
  }
}
