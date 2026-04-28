import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/screens/exercise/exercise_page.dart';

class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({super.key, required this.summary});

  final DayExerciseSummary summary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        PageExercise.routeName,
        arguments: ExercisesPageArguments(
          exerciseId: summary.exercise.id,
          exerciseName: summary.exercise.name,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    summary.exercise.name,
                    style: const TextStyle(
                      color: PPColors.neutral100,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (summary.exercise.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: PPColors.amethyst400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      summary.exercise.category,
                      style: const TextStyle(
                        color: PPColors.amethyst100,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text('SET',
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
                Expanded(
                  child: Text('REPS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
                Expanded(
                  child: Text('WEIGHT',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
              ],
            ),
            const Divider(color: Color(0xFF333333)),
            ...List.generate(summary.sets.length, (i) {
              final set = summary.sets[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: PPColors.amethyst300,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${set.repetitions}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: PPColors.neutral100, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatWeight(set.weight),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: PPColors.neutral100, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < summary.sets.length - 1)
                    const Divider(color: Color(0xFF333333), height: 1),
                ],
              );
            }),
            if (summary.hasRpe) ...[
              const Divider(color: PPColors.amethyst500),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Avg RPE',
                    style: TextStyle(
                        color: PPColors.neutral300, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: PPColors.amethyst500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      summary.avgRpe.toStringAsFixed(1),
                      style: const TextStyle(
                        color: PPColors.amethyst200,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatWeight(double weight) =>
      weight == weight.truncateToDouble()
          ? '${weight.toInt()} kg'
          : '$weight kg';
}
