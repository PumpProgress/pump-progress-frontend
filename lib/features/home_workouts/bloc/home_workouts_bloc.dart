import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'home_workouts_event.dart';
part 'home_workouts_state.dart';

class HomeWorkoutsBloc extends Bloc<HomeWorkoutsEvent, HomeWorkoutsState> {
  HomeWorkoutsBloc({
    required this.pumpProgressRepository,
    required this.coreBloc,
  }) : super(HomeWorkoutsInitial()) {
    on<FetchHomeWorkoutsEvent>(_onFetchHomeWorkoutsEvent);
    on<AddWorkoutHomeWorkoutsEvent>(_onAddWorkoutHomeWorkoutsEvent);
  }

  final PumpProgressRepository pumpProgressRepository;
  final CoreBloc coreBloc;

  Future<void> _onFetchHomeWorkoutsEvent(
      FetchHomeWorkoutsEvent event, Emitter<HomeWorkoutsState> emit) async {
    emit(state.copyWith(status: HomeWorkoutsStatus.loading));

    final userId = coreBloc.state.user.id;

    final workouts = await pumpProgressRepository.getWorkouts(userId: userId);
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
