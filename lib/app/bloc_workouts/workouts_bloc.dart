import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  final PumpProgressRepository pumpProgressRepository;

  WorkoutsBloc({required this.pumpProgressRepository})
      : super(const WorkoutsState()) {
    on<FetchWorkoutsEvent>(_onFetchWorkoutsEvent);
    on<AddWorkoutWorkoutsEvent>(_onAddWorkoutWorkoutsEvent);
    on<AddExerciseToWorkoutEvent>(_onAddExerciseToWorkoutEvent);
  }

  Future<void> _onFetchWorkoutsEvent(
      FetchWorkoutsEvent event, Emitter<WorkoutsState> emit) async {
    emit(state.copyWith(status: WorkoutsStatus.loading));

    final workouts =
        await pumpProgressRepository.getWorkouts(userId: event.userId);

    emit(state.copyWith(
      status: WorkoutsStatus.success,
      workouts: workouts,
    ));
  }

  Future<void> _onAddWorkoutWorkoutsEvent(
      AddWorkoutWorkoutsEvent event, Emitter<WorkoutsState> emit) async {
    emit(state.copyWith(status: WorkoutsStatus.loading));

    try {
      final workout =
          await pumpProgressRepository.postWorkout(name: event.name);

      final workouts = [...state.workouts, workout];

      emit(state.copyWith(
        status: WorkoutsStatus.success,
        workouts: workouts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WorkoutsStatus.success,
        workouts: state.workouts,
      ));
    }
  }

  Future<void> _onAddExerciseToWorkoutEvent(
    AddExerciseToWorkoutEvent event,
    Emitter<WorkoutsState> emit,
  ) async {
    try {
      final updatedWorkout = await pumpProgressRepository.putAddWorkoutExercise(
        workoutId: event.workoutId,
        exerciseId: event.exerciseId,
      );
      final indexWorkout = state.workouts
          .indexWhere((workout) => workout.id == updatedWorkout.id);

      state.workouts[indexWorkout] = updatedWorkout;

      emit(state.copyWith(workouts: List.from(state.workouts)));
    } catch (e) {
      print(e);
    }
  }
}
