import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.pumpProgressRepository})
      : super(const LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
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
}
