import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
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
}
