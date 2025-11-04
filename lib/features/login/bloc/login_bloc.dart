import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/services/cognito_user_pool/cognito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.pumpProgressRepository,
    required this.userPool,
  }) : super(const LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);

    on<LoginWithProvider>(_onLoginWithProvider);
    on<LogInCode>(_onLogInCode);
    on<ResetLogin>(_onResetLogin);
    on<UnknownError>(_onUnknownError);
  }

  final PumpProgressRepository pumpProgressRepository;
  final PPUserPool userPool;

  @Deprecated("Now using cognito")
  Future<void> _onLoginUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.username));
  }

  @Deprecated("Now using cognito")
  Future<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onResetLogin(
    ResetLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState());
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
      final session = await userPool.getTokenDataFromCode(event.code);

      // print debug
      print('Access Token: ${session.accessToken.jwtToken}');
      print('ID Token: ${session.idToken.jwtToken}');
      print('Refresh Token: ${session.refreshToken!.token}');

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
