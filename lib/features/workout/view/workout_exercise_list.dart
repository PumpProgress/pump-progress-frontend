import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_item.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({
    super.key,
    required this.exercisesAtWorkout,
    required this.addExerciseToWorkout,
  });

  final List<ExerciseAtWorkout> exercisesAtWorkout;

  final void Function(String exerciseId) addExerciseToWorkout;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: exercisesAtWorkout.length,
        itemBuilder: (context, index) {
          final exerciseAtWorkout = exercisesAtWorkout[index];
          return ExerciseItemWidget(
            exerciseAtWorkout: exerciseAtWorkout,
          );
        },
      ),
    );
  }
}
