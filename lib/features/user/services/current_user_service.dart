import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/local/local.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bloc-free read of the currently authenticated user.
///
/// Mirrors the session-restore logic in `UserSessionBloc`: the user id comes
/// from the Cognito id token in [SharedPreferences]; the editable profile
/// fields come from [LocalUserProfile]. Returns null when there is no id token
/// (i.e. the user is not authenticated).
class CurrentUserService {
  final LocalUserProfile _localUserProfile = LocalUserProfile();

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString(idTokenKey);
    if (idToken == null) return null;

    final userId =
        CognitoAccessToken(idToken).payload['custom:userID'] as String?;
    if (userId == null || userId.isEmpty) return null;

    final profile = await _localUserProfile.load() ?? const <String, dynamic>{};
    return User(
      id: userId,
      name: '',
      email: '',
      favoriteExercises: const [],
      age: profile['age'] as int?,
      gender: profile['gender'] as String?,
      fitnessLevel: profile['fitnessLevel'] as String?,
      primaryGoal: profile['primaryGoal'] as String?,
      trainingDaysPerWeek: profile['trainingDaysPerWeek'] as int?,
    );
  }
}
