part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
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
