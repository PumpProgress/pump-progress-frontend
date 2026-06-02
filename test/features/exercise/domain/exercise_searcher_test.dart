import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

void main() {
  const benchPress = Exercise(
    id: 1,
    code: 'barbell_bench_press',
    name: 'Barbell Bench Press',
    category: 'Chest',
    muscles: ['Chest', 'Triceps'],
    equipment: 'Barbell',
    mechanic: 'compound',
  );
  const inclineCurl = Exercise(
    id: 2,
    code: 'db_incline_curl',
    name: 'Dumbbell Incline Curl',
    category: 'Arms',
    muscles: ['Biceps'],
    equipment: 'Dumbbell',
    mechanic: 'isolation',
  );
  const squat = Exercise(
    id: 3,
    code: 'barbell_back_squat',
    name: 'Barbell Back Squat',
    category: 'Legs',
    muscles: ['Quadriceps', 'Glutes'],
    equipment: 'Barbell',
    mechanic: 'compound',
  );

  final searcher = ExerciseSearcher([benchPress, inclineCurl, squat]);

  test('empty query returns empty list', () {
    expect(searcher.search(''), isEmpty);
    expect(searcher.search('   '), isEmpty);
  });

  test('exact name match ranks first', () {
    final results = searcher.search('Barbell Bench Press');
    expect(results.first, benchPress);
  });

  test('prefix match surfaces the exercise', () {
    final results = searcher.search('bench');
    expect(results, contains(benchPress));
    expect(results.first, benchPress);
  });

  test('reordered tokens still match', () {
    final results = searcher.search('press bench');
    expect(results.first, benchPress);
  });

  test('typo tolerance', () {
    final results = searcher.search('bemch pres');
    expect(results, contains(benchPress));
  });

  test('code tokens match equipment-led query', () {
    final results = searcher.search('barbell bench');
    expect(results.first, benchPress);
  });

  test('unrelated query below threshold returns nothing', () {
    expect(searcher.search('zzzzzz'), isEmpty);
  });

  test('respects the limit', () {
    final results = searcher.search('barbell', limit: 1);
    expect(results.length, 1);
  });

  // ── New tests ─────────────────────────────────────────────────────────────

  group('Fix 1 – minimum query length', () {
    test('single-character queries return empty', () {
      expect(searcher.search('a'), isEmpty);
      expect(searcher.search('b'), isEmpty);
    });
  });

  group('Fix 2 – no false positives from weak signals', () {
    test("'zz' returns empty (noise below threshold)", () {
      expect(searcher.search('zz'), isEmpty);
    });

    test('purely equipment-brushing query does not flood irrelevant results',
        () {
      // "bb" is not a substring of any exercise name and only weakly matches
      // 'Barbell' via partialRatio. With Fix 2, the weak equipScore (capped at
      // partialRatio*0.3) cannot combine with containsBonus to exceed threshold.
      // All three exercises should be absent.
      final results = searcher.search('bb');
      expect(results, isEmpty);
    });
  });

  group('Fix 3 – hyphen normalization', () {
    test("'dead lift' matches a hyphenated exercise name", () {
      const deadlift = Exercise(
        id: 10,
        code: 'barbell_romanian_deadlift',
        name: 'Romanian Dead-Lift',
        category: 'Legs',
        muscles: ['Hamstrings'],
        equipment: 'Barbell',
      );
      final localSearcher = ExerciseSearcher([deadlift]);
      final results = localSearcher.search('dead lift');
      expect(results, contains(deadlift));
    });
  });

  group('Fix 4 – deterministic sort', () {
    test("'bench' returns benchPress before other results", () {
      final results = searcher.search('bench');
      expect(results.first, benchPress);
    });
  });

  group('Alias match', () {
    test('alias exact match returns the exercise first', () {
      const flatPressExercise = Exercise(
        id: 20,
        code: 'barbell_flat_press',
        name: 'Barbell Flat Press',
        category: 'Chest',
        muscles: ['Chest'],
        equipment: 'Barbell',
        aliases: ['flat press'],
      );
      final localSearcher = ExerciseSearcher([flatPressExercise, squat]);
      final results = localSearcher.search('flat press');
      expect(results.first, flatPressExercise);
    });
  });

  group('Ranking order', () {
    test("'bench' ranks benchPress before squat", () {
      final results = searcher.search('bench');
      expect(results, contains(benchPress));
      // benchPress must come before squat (or squat may not appear at all).
      final benchIdx = results.indexOf(benchPress);
      final squatIdx = results.indexOf(squat);
      expect(benchIdx, 0);
      if (squatIdx != -1) {
        expect(benchIdx, lessThan(squatIdx));
      }
    });
  });
}
