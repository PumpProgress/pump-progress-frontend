import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/workout/bloc/workout_bloc.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_view.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({
    super.key,
    required this.workout,
  });
  final Workout workout;

  static const routeName = '/workouts';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>()),
      child: WorkoutView(workout: workout),
    );
  }
}
