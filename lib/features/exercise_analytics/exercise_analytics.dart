import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/bloc/exercise_analytics_bloc.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/view/exercise_analytics_view.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class ExerciseAnalyticsPage extends StatelessWidget {
  const ExerciseAnalyticsPage({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  final String exerciseId;
  final String exerciseName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseAnalyticsBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>()),
      child: ExerciseAnalyticsView(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
      ),
    );
  }
}
