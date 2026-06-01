import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/local/local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('load returns null when nothing saved', () async {
    final local = LocalUserProfile();
    expect(await local.load(), isNull);
  });

  test('save then load round-trips the five profile fields', () async {
    final local = LocalUserProfile();
    const user = User(
      id: '1',
      name: 'xrok',
      email: 'sercar88@gmail.com',
      favoriteExercises: [],
      age: 30,
      gender: 'Male',
      fitnessLevel: 'Intermediate',
      primaryGoal: 'Build muscle',
      trainingDaysPerWeek: 4,
    );

    await local.save(user);
    final loaded = await local.load();

    expect(loaded, isNotNull);
    expect(loaded!['age'], 30);
    expect(loaded['gender'], 'Male');
    expect(loaded['fitnessLevel'], 'Intermediate');
    expect(loaded['primaryGoal'], 'Build muscle');
    expect(loaded['trainingDaysPerWeek'], 4);
  });

  test('clear removes the stored profile', () async {
    final local = LocalUserProfile();
    const user = User(
      id: '1',
      name: 'xrok',
      email: 'e',
      favoriteExercises: [],
      age: 22,
    );
    await local.save(user);
    await local.clear();
    expect(await local.load(), isNull);
  });
}
