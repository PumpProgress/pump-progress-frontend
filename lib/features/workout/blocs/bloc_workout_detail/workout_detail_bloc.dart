import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository_workout.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'workout_detail_event.dart';
part 'workout_detail_state.dart';

class WorkoutDetailBloc extends Bloc<WorkoutDetailEvent, WorkoutDetailState> {
  final RepositoryWorkout repositoryWorkout;

  WorkoutDetailBloc({required this.repositoryWorkout})
      : super(const WorkoutDetailState()) {
    on<LoadWorkoutDetailEvent>(_onLoadWorkoutDetailEvent);
    on<AddExerciseWorkoutDetailEvent>(_onAddExerciseWorkoutDetailEvent);
    on<RemoveExerciseWorkoutDetailEvent>(_onRemoveExerciseWorkoutDetailEvent);
    on<UpdateSearchValueWorkoutDetailEvent>(
        _onUpdateSearchValueWorkoutDetailEvent);
  }
  Future<void> _onLoadWorkoutDetailEvent(
      LoadWorkoutDetailEvent event, Emitter<WorkoutDetailState> emit) async {
    await runSafeEvent(emit, state, WorkoutDetailStatusError.new, () async {
      emit(state.copyWith(
        status: WorkoutDetailStatusLoading(),
      ));
      final workout =
          await repositoryWorkout.getWorkout(workoutId: event.workoutId);

      emit(state.copyWith(
        status: WorkoutDetailStatusSuccess(),
        workout: workout,
      ));
    });
  }

  Future<void> _onAddExerciseWorkoutDetailEvent(
      AddExerciseWorkoutDetailEvent event,
      Emitter<WorkoutDetailState> emit) async {
    await runSafeEvent(emit, state, WorkoutDetailStatusError.new, () async {
      emit(state.copyWith(
        status: WorkoutDetailStatusLoading(),
      ));
      await repositoryWorkout.addExerciseToWorkout(
          workoutId: state.workout.id,
          exerciseId: event.exerciseId,
          userId: state.workout.userId);
      final workout =
          await repositoryWorkout.getWorkout(workoutId: state.workout.id);

      emit(state.copyWith(
        status: WorkoutDetailStatusSuccess(),
        workout: workout,
      ));
    });
  }

  Future<void> _onRemoveExerciseWorkoutDetailEvent(
      RemoveExerciseWorkoutDetailEvent event,
      Emitter<WorkoutDetailState> emit) async {
    await runSafeEvent(emit, state, WorkoutDetailStatusError.new, () async {
      emit(state.copyWith(
        status: WorkoutDetailStatusLoading(),
      ));
      await repositoryWorkout.deleteExerciseFromWorkout(
        workoutId: state.workout.id,
        exerciseId: event.exerciseId,
      );
      final workout =
          await repositoryWorkout.getWorkout(workoutId: state.workout.id);

      emit(state.copyWith(
        status: WorkoutDetailStatusSuccess(),
        workout: workout,
      ));
    });
  }

  Future<void> _onUpdateSearchValueWorkoutDetailEvent(
      UpdateSearchValueWorkoutDetailEvent event,
      Emitter<WorkoutDetailState> emit) async {
    await runSafeEvent(emit, state, WorkoutDetailStatusError.new, () async {
      emit(state.copyWith(
        status: WorkoutDetailStatusLoading(),
      ));
    });
  }
}
