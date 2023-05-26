import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc({required this.pumpProgressRepository})
      : super(const ExerciseState()) {
    on<LoadSeriesByExercise>(_onLoadSeriesByExercise);
  }

  final PumpProgressRepository pumpProgressRepository;
  Future<void> _onLoadSeriesByExercise(
    LoadSeriesByExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseStatus.loading));
    final sets = await pumpProgressRepository.getMySets();
    emit(state.copyWith(status: ExerciseStatus.success, sets: sets));
  }
}
