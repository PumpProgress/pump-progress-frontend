import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'exercises_event.dart';
part 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  ExercisesBloc({required this.repositoryExercises})
      : super(const ExercisesState()) {
    on<FetchExercisesEvent>(_onFetchExercisesEvent);
  }

  final RepositoryExercises repositoryExercises;

  Future<void> _onFetchExercisesEvent(
      ExercisesEvent event, Emitter<ExercisesState> emit) async {
    await runSafeEvent(emit, () => state, ExercisesStatusError.new, () async {
      emit(state.copyWith(status: ExercisesStatusLoading()));

      final exercises = await repositoryExercises.getExercises();

      emit(state.copyWith(
          status: ExercisesStatusSuccess(), exercises: exercises));
    });
  }
}
