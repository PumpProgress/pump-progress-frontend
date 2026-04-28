import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';

void main() {
  const exercise = Exercise(
    id: 1,
    name: 'Bench Press',
    category: 'Chest',
    muscles: ['Chest'],
  );

  group('DayExerciseSummary.avgRpe', () {
    test('returns 0.0 when sets is empty', () {
      final s = DayExerciseSummary(exercise: exercise, sets: const []);
      expect(s.avgRpe, 0.0);
    });

    test('returns average of intensity values', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 8),
          ExerciseSetEntry(repetitions: 8, weight: 80.0, intensity: 6),
        ],
      );
      expect(s.avgRpe, 7.0);
    });
  });

  group('DayExerciseSummary.hasRpe', () {
    test('returns false when all intensity values are 0', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 0),
        ],
      );
      expect(s.hasRpe, false);
    });

    test('returns true when any intensity value is > 0', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 0),
          ExerciseSetEntry(repetitions: 8, weight: 75.0, intensity: 7),
        ],
      );
      expect(s.hasRpe, true);
    });
  });
}
