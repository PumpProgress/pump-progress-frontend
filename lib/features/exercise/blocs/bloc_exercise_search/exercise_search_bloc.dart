import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'exercise_search_event.dart';
part 'exercise_search_state.dart';

class ExerciseSearchBloc
    extends Bloc<ExerciseSearchEvent, ExerciseSearchState> {
  ExerciseSearchBloc({required this.repositoryExercises})
      : super(ExerciseSearchState()) {
    on<UpdateSearchTermEvent>(_onUpdateSearchTermEvent);
  }

  final RepositoryExercises repositoryExercises;

  Future<void> _onUpdateSearchTermEvent(
    UpdateSearchTermEvent event,
    Emitter<ExerciseSearchState> emit,
  ) async {
    await runSafeEvent(emit, () => state, ExerciseSearchError.new, () async {
      emit(state.copyWith(status: const ExerciseSearchLoading()));

      final exercises =
          await repositoryExercises.searchExercises(event.searchTerm);

      emit(state.copyWith(
        status: const ExerciseSearchSuccess(),
        exercises: exercises,
      ));
    });
  }
}
