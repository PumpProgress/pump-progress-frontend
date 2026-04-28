import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

@immutable
class ExerciseSetEntry {
  const ExerciseSetEntry({
    required this.repetitions,
    required this.weight,
    required this.intensity,
  });

  final int repetitions;
  final double weight;
  final int intensity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExerciseSetEntry &&
        other.repetitions == repetitions &&
        other.weight == weight &&
        other.intensity == intensity;
  }

  @override
  int get hashCode => repetitions.hashCode ^ weight.hashCode ^ intensity.hashCode;
}

@immutable
class DayExerciseSummary {
  const DayExerciseSummary({
    required this.exercise,
    required this.sets,
  });

  final Exercise exercise;
  final List<ExerciseSetEntry> sets;

  double get avgRpe {
    if (sets.isEmpty) return 0.0;
    return sets.fold<double>(0.0, (sum, s) => sum + s.intensity) / sets.length;
  }

  bool get hasRpe => sets.any((s) => s.intensity > 0);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayExerciseSummary &&
        other.exercise == exercise &&
        listEquals(other.sets, sets);
  }

  @override
  int get hashCode => exercise.hashCode ^ sets.hashCode;
}
