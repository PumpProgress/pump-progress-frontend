import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/local/local.dart';
import 'package:pump_progress_frontend/features/user/repository/repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_session_event.dart';
part 'user_session_state.dart';

class UserSessionBloc extends Bloc<UserSessionEvent, UserSessionState> {
  final RepositoryUser repositoryUser;
  final LocalUserProfile localUserProfile = LocalUserProfile();

  UserSessionBloc({required this.repositoryUser}) : super(UserSessionState()) {
    on<UserSessionInitEvent>(_onUserSessionInitEvent);
    on<UserSessionLogoutEvent>(_onUserSessionLogoutEvent);
    on<UserSessionDeleteAccountEvent>(_onUserSessionDeleteAccountEvent);
    on<UserSessionUpdateProfileEvent>(_onUserSessionUpdateProfileEvent);
  }

  Future<void> _onUserSessionInitEvent(
      UserSessionInitEvent event, Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, () => state, UserSessionStatusError.new, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        emit(state.copyWith(status: const UserSessionStatusLoading()));

        final accessToken = prefs.getString(accessTokenKey);
        final refreshToken = prefs.getString(refreshTokenKey);
        final idToken = prefs.getString(idTokenKey);

        if (accessToken == null || refreshToken == null || idToken == null) {
          emit(
              state.copyWith(status: const UserSessionStatusUnauthenticated()));
          return;
        }

        final userId = CognitoAccessToken(idToken).payload['custom:userID'];
        final fetchedUser = await repositoryUser.getUser(userId);
        final user = await _mergeLocalProfile(fetchedUser);

        emit(
          state.copyWith(
            status: const UserSessionStatusAuthenticated(),
            user: user,
          ),
        );

        await Sentry.configureScope(
          (scope) => scope.setUser(
            SentryUser(
              id: user.id,
              email: user.email,
              username: user.name,
            ),
          ),
        );
        return;
      } catch (e) {
        _clearLocalStorage(prefs);
        await Sentry.configureScope((scope) => scope.setUser(null));
        rethrow;
      }
    });
  }

  Future<void> _onUserSessionLogoutEvent(
      UserSessionLogoutEvent event, Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, () => state, UserSessionStatusError.new, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _clearLocalStorage(prefs);
      await localUserProfile.clear();
      emit(state.copyWith(status: const UserSessionStatusUnauthenticated()));
      await Sentry.configureScope((scope) => scope.setUser(null));
    });
  }

  Future<void> _onUserSessionDeleteAccountEvent(
      UserSessionDeleteAccountEvent event,
      Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, () => state, UserSessionStatusError.new, () async {});
  }

  Future<void> _onUserSessionUpdateProfileEvent(
      UserSessionUpdateProfileEvent event,
      Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, () => state, UserSessionStatusError.new, () async {
      final updatedUser = state.user.copyWith(
        age: event.age,
        gender: event.gender,
        fitnessLevel: event.fitnessLevel,
        primaryGoal: event.primaryGoal,
        availableDaysPerWeek: event.availableDaysPerWeek,
      );
      await localUserProfile.save(updatedUser);
      emit(state.copyWith(user: updatedUser));
    });
  }

  Future<User> _mergeLocalProfile(User user) async {
    final profile = await localUserProfile.load();
    if (profile == null) return user;
    return user.copyWith(
      age: profile['age'] as int?,
      gender: profile['gender'] as String?,
      fitnessLevel: profile['fitnessLevel'] as String?,
      primaryGoal: profile['primaryGoal'] as String?,
      availableDaysPerWeek: profile['availableDaysPerWeek'] as int?,
    );
  }
}

void _clearLocalStorage(SharedPreferences prefs) async {
  prefs.remove(accessTokenKey);
  prefs.remove(refreshTokenKey);
  prefs.remove(idTokenKey);
}
