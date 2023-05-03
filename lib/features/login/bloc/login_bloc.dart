import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.localStorage) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  final LocalStorage localStorage;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    print('_onLoginSubmitted');
    try {
      await localStorage.write(LocalStorageKey.jwt, 'token');
      emit(
        state.copyWith(status: LoginStatus.success),
      );
    } catch (e) {
      print(e);
    }
  }
}
