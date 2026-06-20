import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository_workout.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final RepositoryWorkout repositoryWorkout;
  WorkoutBloc({required this.repositoryWorkout}) : super(WorkoutState()) {
    on<FetchWorkoutEvent>(_onFetchWorkouts);
    on<AddWorkoutWorkoutEvent>(_onAddWorkoutWorkoutEvent);
    on<AddExerciseToWorkoutEvent>(_onAddExerciseToWorkoutEvent);
  }
  Future<void> _onFetchWorkouts(
      FetchWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, () => state, WorkoutsBlocStatusError.new, () async {
      final workouts =
          await repositoryWorkout.getWorkouts(userId: event.userId);
      AppLogger.debug('WorkoutBloc._onFetchWorkouts: $workouts');
      emit(state.copyWith(
        status: WorkoutsBlocStatusSuccess(),
        workouts: workouts,
      ));
    });
  }

  Future<void> _onAddWorkoutWorkoutEvent(
      AddWorkoutWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, () => state, WorkoutsBlocStatusError.new, () async {
      emit(state.copyWith(status: WorkoutsBlocStatusLoading()));

      final workout = await repositoryWorkout.createWorkout(
          userId: event.userId, name: event.name);

      final workouts = [workout, ...state.workouts];

      emit(state.copyWith(
        status: WorkoutsBlocStatusSuccess(),
        workouts: workouts,
      ));
    });
  }

  Future<void> _onAddExerciseToWorkoutEvent(
    AddExerciseToWorkoutEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    await runSafeEvent(emit, () => state, WorkoutsBlocStatusError.new, () async {
      emit(state.copyWith(status: WorkoutsBlocStatusLoading()));
      final updatedWorkout = await repositoryWorkout.addExerciseToWorkout(
        workoutId: event.workoutId,
        exerciseId: event.exerciseId,
        userId: event.userId,
      );
      final indexWorkout = state.workouts
          .indexWhere((workout) => workout.id == updatedWorkout.id);

      state.workouts[indexWorkout] = updatedWorkout;

      emit(state.copyWith(workouts: List.from(state.workouts)));
    });
  }
}
