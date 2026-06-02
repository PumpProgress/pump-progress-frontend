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

    test('codeTokens returns an empty list for empty code', () {
      expect(const Exercise.empty().codeTokens, isEmpty);
    });

    test('aliases defaults to an empty list', () {
      expect(ex.aliases, isEmpty);
    });

    test('aliases round-trip through toMap/fromMap', () {
      const withAliases = Exercise(
        id: 2,
        code: 'barbell_bench_press',
        name: 'Barbell Bench Press',
        category: 'Chest',
        muscles: ['Chest'],
        aliases: ['flat press', 'bench'],
      );
      final restored = Exercise.fromMap(withAliases.toMap());
      expect(restored.aliases, ['flat press', 'bench']);
      expect(restored, withAliases);
    });

    test('equal instances share the same hashCode', () {
      expect(ex.hashCode, ex.copyWith().hashCode);
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
