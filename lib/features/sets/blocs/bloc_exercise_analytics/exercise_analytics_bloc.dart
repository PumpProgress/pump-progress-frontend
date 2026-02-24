import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'exercise_analytics_event.dart';
part 'exercise_analytics_state.dart';

class ExerciseAnalyticsBloc
    extends Bloc<ExerciseAnalyticsEvent, ExerciseAnalyticsState> {
  final RepositorySets repositorySets;

  ExerciseAnalyticsBloc({required this.repositorySets})
      : super(const ExerciseAnalyticsState()) {
    on<LoadExerciseAnalyticsEvent>(_onLoadExerciseAnalyticsEvent);
  }

  Future<void> _onLoadExerciseAnalyticsEvent(
    LoadExerciseAnalyticsEvent event,
    Emitter<ExerciseAnalyticsState> emit,
  ) async {
    await runSafeEvent(emit, state, ExerciseAnalyticsStatusError.new, () async {
      emit(state.copyWith(status: const ExerciseAnalyticsStatusLoading()));
      final data = await repositorySets.getExerciseAnalytics(
        exerciseId: event.exerciseId,
        userId: event.userId,
      );
      emit(state.copyWith(
          data: data, status: const ExerciseAnalyticsStatusSuccess()));
    });
  }
}
