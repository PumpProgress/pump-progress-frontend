import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

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
    emit(state.copyWith(
      status: WorkoutPageStatus.loading,
      workout: event.workout,
    ));
  }

  Future<void> _onLoadExercisesWorkoutEvent(
      LoadExercisesWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(state.copyWith(status: WorkoutPageStatus.loading));
    final exercises = await pumpProgressRepository.getExercises();
    final workoutExercises = exercises
        .where((exercise) => state.workout.exercises
            .any((workoutExerciseId) => workoutExerciseId == exercise.id))
        .toList();

    workoutExercises.sort((a, b) {
      return state.workout.exercises.indexOf(a.id) -
          state.workout.exercises.indexOf(b.id);
    });

    emit(state.copyWith(
      status: WorkoutPageStatus.success,
      exercises: exercises,
      workoutExercises: workoutExercises,
    ));
  }

  Future<void> _onAddExerciseWorkoutEvent(
      AddExerciseWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(state.copyWith(status: WorkoutPageStatus.loading));
    final updatedWorkout = await pumpProgressRepository.putAddWorkoutExercise(
      workoutId: state.workout.id,
      exerciseId: event.exerciseId,
    );

    state.workout.exercises.add(event.exerciseId);

    final workoutExercises = state.exercises
        .where((exercise) => updatedWorkout.exercises
            .any((workoutExerciseId) => workoutExerciseId == exercise.id))
        .toList();

    workoutExercises.sort((a, b) {
      return updatedWorkout.exercises.indexOf(a.id) -
          updatedWorkout.exercises.indexOf(b.id);
    });

    emit(state.copyWith(
      status: WorkoutPageStatus.success,
      workoutExercises: workoutExercises,
      workout: updatedWorkout,
    ));
  }

  Future<void> _onRemoveExerciseWorkoutEvent(
      RemoveExerciseWorkoutEvent event, Emitter<WorkoutState> emit) async {
    final updatedWorkout =
        await pumpProgressRepository.putRemoveWorkoutExercise(
      workoutId: state.workout.id,
      exerciseId: event.exerciseId,
    );

    final workoutExercises = state.exercises
        .where((exercise) => updatedWorkout.exercises
            .any((workoutExerciseId) => workoutExerciseId == exercise.id))
        .toList();

    workoutExercises.sort((a, b) {
      return updatedWorkout.exercises.indexOf(a.id) -
          updatedWorkout.exercises.indexOf(b.id);
    });

    emit(state.copyWith(
      status: WorkoutPageStatus.success,
      workoutExercises: workoutExercises,
      workout: updatedWorkout,
    ));
  }
}
