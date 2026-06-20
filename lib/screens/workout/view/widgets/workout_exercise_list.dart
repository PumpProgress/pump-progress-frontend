import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/screens/workout/view/widgets/workout_exercise_item.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({
    super.key,
    required this.exercisesAtWorkout,
  });

  final List<ExerciseAtWorkout> exercisesAtWorkout;

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
