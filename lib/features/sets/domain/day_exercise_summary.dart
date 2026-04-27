import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

class ExerciseSetEntry {
  const ExerciseSetEntry({
    required this.repetitions,
    required this.weight,
    required this.intensity,
  });

  final int repetitions;
  final double weight;
  final int intensity;
}

class DayExerciseSummary {
  const DayExerciseSummary({
    required this.exercise,
    required this.sets,
  });

  final Exercise exercise;
  final List<ExerciseSetEntry> sets;

  double get avgRpe {
    if (sets.isEmpty) return 0.0;
    return sets.fold<int>(0, (sum, s) => sum + s.intensity) / sets.length;
  }

  bool get hasRpe => sets.any((s) => s.intensity > 0);
}
