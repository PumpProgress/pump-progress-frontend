import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/helpers.dart';
import 'package:pump_progress_frontend/utils/services/congito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.pumpProgressRepository})
      : super(const LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithProvider>(_onLoginWithProvider);
    on<LogInCode>(_onLogInCode);
    on<UnknownError>(_onUnknownError);
  }

  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onLoginUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.username));
  }

  Future<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final token = await pumpProgressRepository.authLogIn(
        email: state.email,
        password: state.password,
      );
      final payload = parseJwt(token);
      await prefs.setString(jwtKey, token);
      await prefs.setString(userKey, payload['iss']);

      emit(
        state.copyWith(status: LoginStatus.success),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onLoginWithProvider(
    LoginWithProvider event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
          status: LoginStatus.providerLogIn, provider: event.provider),
    );
  }

  Future<void> _onLogInCode(
    LogInCode event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final SharedPreferences sharedPref =
          await SharedPreferences.getInstance();
      final session = await getTokenDataFromCode(event.code);

      await sharedPref.setString(accessTokenKey, session.idToken.jwtToken!);
      await sharedPref.setString(refreshTokenKey, session.refreshToken!.token!);
      await sharedPref.setString(idTokenKey, session.accessToken.jwtToken!);

      emit(
        state.copyWith(status: LoginStatus.success),
      );
    } catch (e) {
      print(e);
      emit(
        state.copyWith(status: LoginStatus.error, error: e.toString()),
      );
      print(e);
    }
  }

  Future<void> _onUnknownError(
    UnknownError event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.error));
  }
}
