import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

void main() {
  group('Exercise', () {
    const ex = Exercise(
      id: 1,
      code: 'barbell_bench_press',
      name: 'Barbell Bench Press',
      category: 'Chest',
      muscles: ['Chest', 'Triceps'],
      equipment: 'Barbell',
      force: 'push',
      mechanic: 'compound',
      level: 'beginner',
    );

    test('codeTokens splits the code on underscores', () {
      expect(ex.codeTokens, ['barbell', 'bench', 'press']);
    });

    test('aliases defaults to an empty list', () {
      expect(ex.aliases, isEmpty);
    });

    test('copyWith overrides only provided fields', () {
      final updated = ex.copyWith(name: 'Bench Press', equipment: 'Dumbbell');
      expect(updated.name, 'Bench Press');
      expect(updated.equipment, 'Dumbbell');
      expect(updated.code, 'barbell_bench_press');
      expect(updated.force, 'push');
    });

    test('round-trips through toMap/fromMap', () {
      final restored = Exercise.fromMap(ex.toMap());
      expect(restored, ex);
    });
  });
}
