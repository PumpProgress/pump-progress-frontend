import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';

class ExerciseItemWidget extends StatelessWidget {
  const ExerciseItemWidget({
    super.key,
    required this.exerciseAtWorkout,
  });

  final ExerciseAtWorkout exerciseAtWorkout;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(8)),
              onPressed: (context) => context.read<WorkoutDetailBloc>()
                ..add(RemoveExerciseWorkoutDetailEvent(
                    exerciseId: exerciseAtWorkout.exercise.id)),
              backgroundColor: const Color.fromARGB(255, 196, 42, 42),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Remove',
            )
          ],
        ),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          color: PPColors.amethyst500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                '/exercises',
                arguments: ExercisesPageArguments(
                    exerciseId: exerciseAtWorkout.exercise.id,
                    exerciseName: exerciseAtWorkout.exercise.name),
              );
              if (context.mounted) {
                context.read<WorkoutDetailBloc>().add(LoadWorkoutDetailEvent(
                    workoutId: context
                        .read<WorkoutDetailBloc>()
                        .state
                        .workout
                        .id));
              }
            },
            title: Text(
              exerciseAtWorkout.exercise.name,
              style: TextTheme.of(context).titleMedium?.copyWith(
                    color: PPColors.amethyst100,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Wrap(
                spacing: 8.0,
                children: exerciseAtWorkout.exercise.muscles
                    .map(
                      (muscle) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        child: Text(
                          muscle.toUpperCase(),
                          style: TextTheme.of(context).labelSmall?.copyWith(
                                color: PPColors.coral300,
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${exerciseAtWorkout.seriesToday}',
                style: TextTheme.of(context).labelLarge?.copyWith(
                      color: PPColors.coral300,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
