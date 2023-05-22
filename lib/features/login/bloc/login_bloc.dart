import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.localStorage, required this.pumpProgressRepository})
      : super(const LoginState()) {
    on<LoginUsernameChanged>(_onLoginUsernameChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  final LocalStorage localStorage;
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
      final data = await pumpProgressRepository.authLogIn(
        email: state.email,
        password: state.password,
      );

      await localStorage.write(LocalStorageKey.jwt, data);
      emit(
        state.copyWith(status: LoginStatus.success),
      );
    } catch (e) {
      print(e);
    }
  }
}
