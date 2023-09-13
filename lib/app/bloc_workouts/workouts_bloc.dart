import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  WorkoutsBloc({required this.pumpProgressRepository})
      : super(const WorkoutsState()) {
    on<FetchWorkoutsEvent>(_onFetchWorkoutsEvent);
    on<AddWorkoutWorkoutsEvent>(_onAddWorkoutWorkoutsEvent);
    on<AddExerciseToWorkoutEvent>(_onAddExerciseToWorkoutEvent);
  }
  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onFetchWorkoutsEvent(
      FetchWorkoutsEvent event, Emitter<WorkoutsState> emit) async {
    emit(state.copyWith(status: WorkoutsStatus.loading));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(userKey);

    final workouts = await pumpProgressRepository.getWorkouts(userId: userId);

    emit(state.copyWith(
      status: WorkoutsStatus.success,
      workouts: workouts,
    ));
  }

  Future<void> _onAddWorkoutWorkoutsEvent(
      AddWorkoutWorkoutsEvent event, Emitter<WorkoutsState> emit) async {
    emit(state.copyWith(status: WorkoutsStatus.loading));

    final workout = await pumpProgressRepository.postWorkout(name: event.name);

    final workouts = [...state.workouts, workout];

    emit(state.copyWith(
      status: WorkoutsStatus.success,
      workouts: workouts,
    ));
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
