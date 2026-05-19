import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/screens/ai/workout_builder/view/workout_builder_view.dart';

class WorkoutBuilderPage extends StatelessWidget {
  const WorkoutBuilderPage({super.key});

  static const routeName = '/ai/workout-builder';

  @override
  Widget build(BuildContext context) {
    return const WorkoutBuilderView();
  }
}
