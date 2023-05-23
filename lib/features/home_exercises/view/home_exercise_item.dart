import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class HomeExerciseItem extends StatelessWidget {
  const HomeExerciseItem({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(exercise.name), const Icon(Icons.star)],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: exercise.muscles
                .map<Widget>(
                  (m) => MuscleChip(
                    muscle: m,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class MuscleChip extends StatelessWidget {
  const MuscleChip({super.key, required this.muscle});
  final String muscle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: Text(muscle),
    );
  }
}
