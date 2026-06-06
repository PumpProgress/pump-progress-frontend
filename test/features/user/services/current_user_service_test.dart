import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/local/local.dart';
import 'package:pump_progress_frontend/features/user/services/current_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds a minimal unsigned JWT whose payload carries [payload]. The Cognito
/// token decoder only base64-decodes the middle segment, so the signature can
/// be any string.
String fakeIdToken(Map<String, dynamic> payload) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(json.encode(m))).replaceAll('=', '');
  return '${seg({'alg': 'none'})}.${seg(payload)}.sig';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('returns null when there is no id token', () async {
    final user = await CurrentUserService().getCurrentUser();
    expect(user, isNull);
  });

  test('returns user id from the token with null profile fields', () async {
    SharedPreferences.setMockInitialValues({
      idTokenKey: fakeIdToken({'custom:userID': 'user-1'}),
    });
    final user = await CurrentUserService().getCurrentUser();
    expect(user, isNotNull);
    expect(user!.id, 'user-1');
    expect(user.age, isNull);
    expect(user.trainingDaysPerWeek, isNull);
  });

  test('merges the locally saved profile fields', () async {
    SharedPreferences.setMockInitialValues({
      idTokenKey: fakeIdToken({'custom:userID': 'user-1'}),
    });
    await LocalUserProfile().save(const User(
      id: 'user-1',
      name: 'x',
      email: 'e',
      favoriteExercises: [],
      age: 28,
      gender: 'Male',
      fitnessLevel: 'Advanced',
      primaryGoal: 'Build muscle',
      trainingDaysPerWeek: 5,
    ));

    final user = await CurrentUserService().getCurrentUser();
    expect(user!.id, 'user-1');
    expect(user.age, 28);
    expect(user.fitnessLevel, 'Advanced');
    expect(user.primaryGoal, 'Build muscle');
    expect(user.trainingDaysPerWeek, 5);
  });
}
