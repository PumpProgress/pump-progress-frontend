import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/exercise_analytics/view/exercise_analytics_view.dart';

class ExerciseAnalyticsPage extends StatelessWidget {
  const ExerciseAnalyticsPage({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  final int exerciseId;
  final String exerciseName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExerciseAnalyticsBloc(repositorySets: context.read<RepositorySets>())
            ..add(LoadExerciseAnalyticsEvent(
                exerciseId: exerciseId,
                userId: context.read<UserSessionBloc>().state.user.id)),
      child: ExerciseAnalyticsView(),
    );
  }
}
