import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/repository/repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_session_event.dart';
part 'user_session_state.dart';

class UserSessionBloc extends Bloc<UserSessionEvent, UserSessionState> {
  final RepositoryUser repositoryUser;

  UserSessionBloc({required this.repositoryUser}) : super(UserSessionState()) {
    on<UserSessionInitEvent>(_onUserSessionInitEvent);
    on<UserSessionLogoutEvent>(_onUserSessionLogoutEvent);
    on<UserSessionDeleteAccountEvent>(_onUserSessionDeleteAccountEvent);
  }

  Future<void> _onUserSessionInitEvent(
      UserSessionInitEvent event, Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, state, UserSessionStatusError.new, () async {
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

        final userId = CognitoAccessToken(accessToken).payload['custom:userID'];
        final user = await repositoryUser.getUser(userId);

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
    await runSafeEvent(emit, state, UserSessionStatusError.new, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _clearLocalStorage(prefs);
      emit(state.copyWith(status: const UserSessionStatusUnauthenticated()));
      await Sentry.configureScope((scope) => scope.setUser(null));
    });
  }

  Future<void> _onUserSessionDeleteAccountEvent(
      UserSessionDeleteAccountEvent event,
      Emitter<UserSessionState> emit) async {
    await runSafeEvent(emit, state, UserSessionStatusError.new, () async {});
  }
}

void _clearLocalStorage(SharedPreferences prefs) async {
  prefs.remove(accessTokenKey);
  prefs.remove(refreshTokenKey);
  prefs.remove(idTokenKey);
}
