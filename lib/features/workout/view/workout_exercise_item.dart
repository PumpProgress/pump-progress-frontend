import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class ExerciseItemWidget extends StatelessWidget {
  const ExerciseItemWidget({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
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
                    labelPadding: EdgeInsets.all(0.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
    );
  }
}
