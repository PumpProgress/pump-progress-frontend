import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';

class WorkoutWidgetItem extends StatelessWidget {
  const WorkoutWidgetItem({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutsBloc, WorkoutsState>(
      builder: (context, state) {
        final workout = state.workouts[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed(
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
      },
    );
  }
}
