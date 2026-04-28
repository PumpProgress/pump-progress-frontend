import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';

import 'package:pump_progress_frontend/screens/exercise_analytics/view/widgets/average_bar_chart.dart';
import 'package:pump_progress_frontend/screens/exercise_analytics/view/widgets/max_bar_chart.dart';
import 'package:pump_progress_frontend/screens/exercise_analytics/view/widgets/volume_bar_chart.dart';

class ExerciseAnalyticsView extends StatefulWidget {
  const ExerciseAnalyticsView({super.key});

  @override
  State<ExerciseAnalyticsView> createState() => _ExerciseAnalyticsViewState();
}

class _ExerciseAnalyticsViewState extends State<ExerciseAnalyticsView> {
  @override
  Widget build(BuildContext context) {
    final exerciseName = context.read<SetsByExerciseBloc>().state.exercise.name;
    return Scaffold(
        appBar: AppBar(
          title: Text('$exerciseName Analytics'),
        ),
        body: BlocBuilder<ExerciseAnalyticsBloc, ExerciseAnalyticsState>(
          builder: (context, state) {
            print(state.status);
            switch (state.status) {
              case ExerciseAnalyticsStatusLoading():
                return const Center(child: CircularProgressIndicator());
              case ExerciseAnalyticsStatusSuccess():
                // Display the analytics data
                return SingleChildScrollView(
                  child: Column(
                    // padding: const EdgeInsets.all(32.0),
                    // spacing: 16.0,
                    children: [
                      WorkoutVolumeBarChart(rawData: state.data),
                      WorkoutAverageBarChart(rawData: state.data),
                      MaxWeightBarChart(rawData: state.data),
                    ],
                  ),
                );
              case ExerciseAnalyticsStatusError():
                return Center(
                  child: Text('Failed to load analytics data.'),
                );
            }
          },
        ));
  }
}
