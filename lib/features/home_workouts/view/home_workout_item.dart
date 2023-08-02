import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/home_workouts/bloc/home_workouts_bloc.dart';

class WorkoutWidgetItem extends StatelessWidget {
  const WorkoutWidgetItem({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    final homeWorkoutBloc = context.read<HomeWorkoutsBloc>();
    final workout = homeWorkoutBloc.state.workouts[index];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          '/workouts',
          arguments: WorkoutsPageArguments(workout: workout),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: Text('${workout.exercises.length} exercises'),
      ),
    );
  }
}
