import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_item.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ExerciseItemWidget(
            exercise: exercise,
          );
        },
      ),
    );
  }
}
