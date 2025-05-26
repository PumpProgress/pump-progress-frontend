import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/workout_session.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'start_home_event.dart';
part 'start_home_state.dart';

class StartHomeBloc extends Bloc<StartHomeEvent, StartHomeState> {
  StartHomeBloc({required this.pumpProgressRepository})
      : super(StartHomeState()) {
    on<FetchInitialWorkoutSessions>(_onFetchInitialWorkoutSessions);
    on<FetchNextWorkoutSessions>(_onFetchNextWorkoutSessions);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onFetchInitialWorkoutSessions(
      FetchInitialWorkoutSessions event, Emitter<StartHomeState> emit) async {
    // try {
    emit(state.copyWith(status: StartHomeStatus.loading));
    final workoutSessions = await pumpProgressRepository.getWorkoutSessions();
    emit(state.copyWith(
      status: StartHomeStatus.success,
      workoutSessions: workoutSessions,
    ));
    // } catch (e) {
    //   print(e.toString());
    //   emit(state.copyWith(status: StartHomeStatus.error));
    // }
  }

  Future<void> _onFetchNextWorkoutSessions(
      FetchNextWorkoutSessions event, Emitter<StartHomeState> emit) async {
    try {
      emit(state.copyWith(status: StartHomeStatus.loading));
      final workoutSessions = await pumpProgressRepository.getWorkoutSessions(
          offset: state.workoutSessions.length);

      emit(state.copyWith(
        status: StartHomeStatus.success,
        workoutSessions: [...state.workoutSessions, ...workoutSessions],
        areMore: workoutSessions.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(status: StartHomeStatus.error));
    }
  }
}
