import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/workout/blocs/bloc_workout/workout_bloc.dart';

class WorkoutWidgetItem extends StatelessWidget {
  WorkoutWidgetItem({
    super.key,
    required this.index,
  });
  final int index;

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        final workout = state.workouts[index];
        return Card(
          // elevation: 2,
          color: PPColors.amethyst500,
          margin: const EdgeInsets.only(bottom: 16),
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
              style: TextTheme.of(context)
                  .titleSmall
                  ?.copyWith(color: PPColors.amethyst100),
            ),
            trailing: Text(
              '${workout.exercisesCount} exercises',
              style: TextTheme.of(context)
                  .titleSmall
                  ?.copyWith(color: PPColors.amethyst100),
            ),
          ),
        );
      },
    );
  }
}
