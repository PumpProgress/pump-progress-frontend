import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_add_exercise_button.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_item.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList(
      {super.key,
      required this.exercises,
      required this.addExerciseToWorkout,
      required this.totalExercises});

  final List<Exercise> exercises;
  final List<Exercise> totalExercises;
  final void Function(String exerciseId) addExerciseToWorkout;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: exercises.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return WorkoutAddExerciseItemButton(
              addExerciseToWorkout: addExerciseToWorkout,
              exercises: totalExercises,
            );
          }
          final exercise = exercises[index - 1];
          return ExerciseItemWidget(
            exercise: exercise,
          );
        },
      ),
    );
  }
}
