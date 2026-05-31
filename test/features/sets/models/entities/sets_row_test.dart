import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/sets/models/entities/sets_row.dart';

void main() {
  group('SetsRow.fromMap weight parsing', () {
    Map<String, dynamic> baseMap() => <String, dynamic>{
          'id': 'abc',
          'userId': 'user-1',
          'exerciseId': 1,
          'createdAt': '2026-05-31T00:00:00.000Z',
          'updatedAt': '2026-05-31T00:00:00.000Z',
          'deletedAt': null,
          'repetitions': 10,
          'intensity': 8,
          'isDirty': 0,
        };

    test('parses integer weight from sync payload', () {
      // Server serializes whole numbers as int (100, not 100.0).
      final row = SetsRow.fromMap(baseMap()..['weight'] = 100);
      expect(row.weight, 100.0);
    });

    test('parses double weight from sync payload', () {
      final row = SetsRow.fromMap(baseMap()..['weight'] = 82.5);
      expect(row.weight, 82.5);
    });
  });
}
