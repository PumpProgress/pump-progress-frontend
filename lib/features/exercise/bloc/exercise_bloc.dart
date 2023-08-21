import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc({required this.pumpProgressRepository, required this.coreState})
      : super(const ExerciseState()) {
    on<LoadSeriesByExercise>(_onLoadSeriesByExercise);
    on<AddNewSeries>(_onAddNewSeries);
  }

  final PumpProgressRepository pumpProgressRepository;
  final CoreState coreState;

  Future<void> _onLoadSeriesByExercise(
    LoadSeriesByExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ExerciseStatus.loading));
      final sets = await pumpProgressRepository.getSets(
          exerciseId: event.exerciseId, userId: coreState.user.id);
      emit(
        state.copyWith(
          status: ExerciseStatus.success,
          sets: sets,
          exerciseId: event.exerciseId,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAddNewSeries(
    AddNewSeries event,
    Emitter<ExerciseState> emit,
  ) async {
    final series = await pumpProgressRepository.postSeries(
      exerciseId: event.exerciseId,
      repetitions: event.repetitions,
      weight: event.weight,
    );
    final sets = List<Series>.from(state.sets);
    sets.insert(0, series);

    emit(state.copyWith(sets: sets));
  }
}
