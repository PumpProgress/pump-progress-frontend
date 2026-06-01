import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/user/domain/user.dart';

void main() {
  group('User profile fields', () {
    const fullUser = User(
      id: '1',
      name: 'xrok',
      email: 'sercar88@gmail.com',
      favoriteExercises: ['squat'],
      age: 30,
      gender: 'Male',
      fitnessLevel: 'Intermediate',
      primaryGoal: 'Build muscle',
      trainingDaysPerWeek: 4,
    );

    test('toMap/fromMap round-trip preserves profile fields', () {
      final restored = User.fromMap(fullUser.toMap());
      expect(restored, equals(fullUser));
    });

    test('fromMap tolerates a map missing all profile keys (API payload)', () {
      final apiMap = {
        'id': '1',
        'name': 'xrok',
        'email': 'sercar88@gmail.com',
        'favoriteExercises': <String>['squat'],
      };
      final user = User.fromMap(apiMap);
      expect(user.age, isNull);
      expect(user.gender, isNull);
      expect(user.fitnessLevel, isNull);
      expect(user.primaryGoal, isNull);
      expect(user.trainingDaysPerWeek, isNull);
    });

    test('copyWith overrides profile fields', () {
      final updated = User.unknown.copyWith(age: 25, gender: 'Female');
      expect(updated.age, 25);
      expect(updated.gender, 'Female');
      // Untouched fields are preserved.
      expect(updated.id, User.unknown.id);
      expect(updated.name, User.unknown.name);
      expect(updated.email, User.unknown.email);
      expect(updated.fitnessLevel, isNull);
      expect(updated.primaryGoal, isNull);
      expect(updated.trainingDaysPerWeek, isNull);
    });
  });
}
