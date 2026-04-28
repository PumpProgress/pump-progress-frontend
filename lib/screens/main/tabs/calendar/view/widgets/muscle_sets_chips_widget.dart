import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';

class MuscleSetsChipsWidget extends StatelessWidget {
  const MuscleSetsChipsWidget({super.key, required this.summaries});

  final List<DayExerciseSummary> summaries;

  static const _chipColors = [
    PPColors.amethyst400,
    PPColors.coral300,
    PPColors.amethyst300,
    PPColors.coral200,
  ];

  @override
  Widget build(BuildContext context) {
    final muscleSetCount = <String, int>{};
    for (final summary in summaries) {
      final label = summary.exercise.muscles.isNotEmpty
          ? summary.exercise.muscles.first
          : 'Other';

      muscleSetCount[label] =
          (muscleSetCount[label] ?? 0) + summary.sets.length;
    }

    if (muscleSetCount.isEmpty) return const SizedBox.shrink();

    final entries = muscleSetCount.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SETS BY MUSCLE',
            style: TextStyle(
              color: PPColors.neutral300,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(entries.length, (i) {
              final color = _chipColors[i % _chipColors.length];
              return _MuscleChip(
                muscle: entries[i].key,
                setCount: entries[i].value,
                color: color,
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({
    required this.muscle,
    required this.setCount,
    required this.color,
  });
  final String muscle;
  final int setCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: PPColors.neutral500,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PPColors.neutral400, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            muscle,
            style: const TextStyle(color: PPColors.neutral100, fontSize: 13),
          ),
          const SizedBox(width: 6),
          Text(
            '$setCount sets',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
