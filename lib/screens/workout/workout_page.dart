import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';

import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository_workout.dart';
import 'package:pump_progress_frontend/screens/workout/view/workout_view.dart';

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
      create: (context) => WorkoutDetailBloc(
        repositoryWorkout: context.read<RepositoryWorkout>(),
      )..add(LoadWorkoutDetailEvent(workoutId: workout.id)),
      child: WorkoutView(workout: workout),
    );
  }
}
