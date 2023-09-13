import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/workout/bloc/workout_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class ExerciseItemWidget extends StatelessWidget {
  const ExerciseItemWidget({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(8)),
              onPressed: (context) => context.read<WorkoutBloc>()
                ..add(RemoveExerciseWorkoutEvent(exerciseId: exercise.id)),
              backgroundColor: const Color.fromARGB(255, 196, 42, 42),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Remove',
            )
          ],
        ),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed(
              '/exercises',
              arguments: ExercisesPageArguments(
                  exerciseId: exercise.id, exerciseName: exercise.name),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8.0,
                runSpacing: -8.0,
                children: exercise.muscles
                    .map(
                      (muscle) => Chip(
                        labelPadding: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        side: const BorderSide(
                            color: PumpProgressColors.coral, width: 0.5),
                        label: Text(
                          muscle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
