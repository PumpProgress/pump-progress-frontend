import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc({
    required this.pumpProgressRepository,
  }) : super(const WorkoutState()) {
    on<InitWorkoutEvent>(_onInitWorkoutEvent);
    on<LoadExercisesWorkoutEvent>(_onLoadExercisesWorkoutEvent);
    on<AddExerciseWorkoutEvent>(_onAddExerciseWorkoutEvent);
    on<RemoveExerciseWorkoutEvent>(_onRemoveExerciseWorkoutEvent);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onInitWorkoutEvent(
      InitWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, state, WorkoutPageStatusError.new, () async {
      emit(state.copyWith(
        status: WorkoutPageStatusLoading(),
        workout: event.workout,
      ));
    });
  }

  Future<void> _onLoadExercisesWorkoutEvent(
      LoadExercisesWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, state, WorkoutPageStatusError.new, () async {
      emit(state.copyWith(status: WorkoutPageStatusLoading()));

      final workout = await pumpProgressRepository.getWorkoutById(
        workoutId: state.workout.id,
      );

      emit(state.copyWith(
        status: WorkoutPageStatusSuccess(),
        workout: workout,
      ));
    });
  }

  Future<void> _onAddExerciseWorkoutEvent(
      AddExerciseWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, state, WorkoutPageStatusError.new, () async {
      emit(state.copyWith(status: WorkoutPageStatusLoading()));

      await pumpProgressRepository.putAddWorkoutExercise(
        workoutId: state.workout.id,
        exerciseId: event.exerciseId,
      );

      final workout = await pumpProgressRepository.getWorkoutById(
        workoutId: state.workout.id,
      );

      emit(state.copyWith(
        status: WorkoutPageStatusSuccess(),
        workout: workout,
      ));
    });
  }

  Future<void> _onRemoveExerciseWorkoutEvent(
      RemoveExerciseWorkoutEvent event, Emitter<WorkoutState> emit) async {
    await runSafeEvent(emit, state, WorkoutPageStatusError.new, () async {
      emit(state.copyWith(status: WorkoutPageStatusLoading()));

      await pumpProgressRepository.putRemoveWorkoutExercise(
        workoutId: state.workout.id,
        exerciseId: event.exerciseId,
      );

      final workout = await pumpProgressRepository.getWorkoutById(
        workoutId: state.workout.id,
      );

      emit(state.copyWith(
        status: WorkoutPageStatusSuccess(),
        workout: workout,
      ));
    });
  }
}
