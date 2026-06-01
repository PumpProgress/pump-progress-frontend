import 'dart:convert';

import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the local-only profile fields of [User] as a JSON blob in
/// SharedPreferences. These fields are not returned by the backend API.
class LocalUserProfile {
  Future<void> save(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'age': user.age,
      'gender': user.gender,
      'fitnessLevel': user.fitnessLevel,
      'primaryGoal': user.primaryGoal,
      'trainingDaysPerWeek': user.trainingDaysPerWeek,
    };
    await prefs.setString(userProfileKey, json.encode(map));
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(userProfileKey);
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      AppLogger.error(
        'LocalUserProfile.load failed to decode stored profile',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userProfileKey);
  }
}
