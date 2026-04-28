import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/features/auth/repository/repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.repositoryAuth}) : super(LoginState()) {
    on<LoginWithProvider>(_onLoginWithProvider);
    on<LogInCode>(_onLogInCode);
    on<UnknownError>(_onUnknownError);
    on<ResetLogin>(_onResetLogin);
  }

  final RepositoryAuth repositoryAuth;

  Future<void> _onLoginWithProvider(
      LoginWithProvider event, Emitter<LoginState> emit) async {
    await runSafeEvent(emit, state, LoginStatusError.new, () async {
      emit(
        state.copyWith(
            status: LoginStatusProviderLogIn(), provider: event.provider),
      );
    });
  }

  Future<void> _onLogInCode(LogInCode event, Emitter<LoginState> emit) async {
    await runSafeEvent(emit, state, LoginStatusError.new, () async {
      emit(state.copyWith(status: LoginStatusLoading()));

      final SharedPreferences sharedPref =
          await SharedPreferences.getInstance();

      final session = await repositoryAuth.getTokenDataFromCode(event.code);

      await sharedPref.setString(accessTokenKey, session.idToken.jwtToken!);
      await sharedPref.setString(refreshTokenKey, session.refreshToken!.token!);
      await sharedPref.setString(idTokenKey, session.accessToken.jwtToken!);

      emit(
        state.copyWith(status: LoginStatusSuccess()),
      );
    });
  }

  Future<void> _onUnknownError(
      UnknownError event, Emitter<LoginState> emit) async {
    await runSafeEvent(emit, state, LoginStatusError.new, () async {
      throw Exception("An unknown error occurred");
    });
  }

  Future<void> _onResetLogin(ResetLogin event, Emitter<LoginState> emit) async {
    await runSafeEvent(emit, state, LoginStatusError.new, () async {
      emit(const LoginState());
    });
  }
}
