import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';

class DayStatsSummaryWidget extends StatelessWidget {
  const DayStatsSummaryWidget({super.key, required this.summaries});

  final List<DayExerciseSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final totalSets =
        summaries.fold<int>(0, (sum, s) => sum + s.sets.length);
    final totalVolume = summaries.fold<double>(
      0.0,
      (sum, s) => sum +
          s.sets.fold<double>(
              0.0, (v, set) => v + set.repetitions * set.weight),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: PPColors.amethyst500,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(label: 'Exercises', value: '${summaries.length}'),
          const VerticalDivider(color: Color(0xFF5D3888), width: 1),
          _StatColumn(label: 'Total Sets', value: '$totalSets'),
          const VerticalDivider(color: Color(0xFF5D3888), width: 1),
          _StatColumn(label: 'Volume', value: _formatVolume(totalVolume)),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}k kg';
    return '${volume.toStringAsFixed(0)} kg';
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: PPColors.amethyst100,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: PPColors.neutral100,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
