import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'exercises_event.dart';
part 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  ExercisesBloc({required this.pumpProgressRepository})
      : super(const ExercisesState()) {
    on<FetchExercisesEvent>(_onFetchExercisesEvent);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onFetchExercisesEvent(
      ExercisesEvent event, Emitter<ExercisesState> emit) async {
    await runSafeEvent(emit, state, ExercisesStatusError.new, () async {
      emit(const ExercisesState(status: ExercisesStatusLoading()));

      final exercises = await pumpProgressRepository.getExercises();
      emit(ExercisesState(
          status: ExercisesStatusSuccess(), exercises: exercises));
    });
  }
}
