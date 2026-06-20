part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithProvider extends LoginEvent {
  final String provider;

  const LoginWithProvider({required this.provider});

  @override
  List<Object> get props => [provider];
}

class LogInCode extends LoginEvent {
  final String code;

  const LogInCode({required this.code});

  @override
  List<Object> get props => [code];
}

class UnknownError extends LoginEvent {
  const UnknownError();
}

class ResetLogin extends LoginEvent {
  const ResetLogin();
}
