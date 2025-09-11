import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'exercise_analytics_event.dart';
part 'exercise_analytics_state.dart';

class ExerciseAnalyticsBloc
    extends Bloc<ExerciseAnalyticsEvent, ExerciseAnalyticsState> {
  ExerciseAnalyticsBloc({
    required this.pumpProgressRepository,
  }) : super(ExerciseAnalyticsInitial()) {
    on<LoadExerciseAnalyticsEvent>(_onLoadExerciseAnalytics);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onLoadExerciseAnalytics(
    LoadExerciseAnalyticsEvent event,
    Emitter<ExerciseAnalyticsState> emit,
  ) async {
    try {
      emit(ExerciseAnalyticsState());
      final data = await pumpProgressRepository.getExerciseAnalytics(
          exerciseId: event.exerciseId, userId: event.userId);
      emit(state.copyWith(data: data, status: ExerciseAnalyticsStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ExerciseAnalyticsStatus.failure, lastError: DateTime.now()));
    }
  }
}
