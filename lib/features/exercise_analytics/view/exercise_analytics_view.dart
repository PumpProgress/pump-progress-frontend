import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/bloc/exercise_analytics_bloc.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/view/average_bar_chart.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/view/max_bar_chart.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/view/volume_bar_chart.dart';

class ExerciseAnalyticsView extends StatefulWidget {
  const ExerciseAnalyticsView(
      {super.key, required this.exerciseId, required this.exerciseName});

  @override
  State<ExerciseAnalyticsView> createState() => _ExerciseAnalyticsViewState();
  final String exerciseId;
  final String exerciseName;
}

class _ExerciseAnalyticsViewState extends State<ExerciseAnalyticsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = context.read<CoreBloc>().state.user;
    // emit event to load exercise analytics data
    context.read<ExerciseAnalyticsBloc>().add(LoadExerciseAnalyticsEvent(
        exerciseId: widget.exerciseId, userId: user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.exerciseName} Analytics'),
        ),
        body: BlocBuilder<ExerciseAnalyticsBloc, ExerciseAnalyticsState>(
          builder: (context, state) {
            print(state.status);
            switch (state.status) {
              case ExerciseAnalyticsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ExerciseAnalyticsStatus.success:
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
              case ExerciseAnalyticsStatus.failure:
                return Center(
                  child: Text('Failed to load analytics data.'),
                );
            }
          },
        ));
  }
}
