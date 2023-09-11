import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  WorkoutsBloc() : super(WorkoutsInitial()) {
    on<WorkoutsEvent>((event, emit) {
      on<FetchHomeWorkoutsEvent>(_onFetchHomeWorkoutsEvent);
      on<AddWorkoutHomeWorkoutsEvent>(_onAddWorkoutHomeWorkoutsEvent);
    });
  }

  Future<void> _onFetchHomeWorkoutsEvent(
      FetchHomeWorkoutsEvent event, Emitter<HomeWorkoutsState> emit) async {
    emit(state.copyWith(status: HomeWorkoutsStatus.loading));

    final workouts = coreBloc.state.workouts;

    emit(state.copyWith(
      status: HomeWorkoutsStatus.success,
      workouts: workouts,
    ));
  }

  Future<void> _onAddWorkoutHomeWorkoutsEvent(AddWorkoutHomeWorkoutsEvent event,
      Emitter<HomeWorkoutsState> emit) async {
    emit(state.copyWith(status: HomeWorkoutsStatus.loading));
    await pumpProgressRepository.postWorkout(name: event.name);
    final userId = coreBloc.state.user.id;
    final workouts = await pumpProgressRepository.getWorkouts(userId: userId);
    emit(state.copyWith(
      status: HomeWorkoutsStatus.success,
      workouts: workouts,
    ));
  }
}
