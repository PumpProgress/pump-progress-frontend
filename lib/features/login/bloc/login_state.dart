part of 'login_bloc.dart';

enum LoginStatus {
  loading,
  success,
  error,
  initial,
  providerLogIn,
  providerValidateToken
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.password = '',
    this.provider = '',
    this.error = '',
  });

  final LoginStatus status;
  final String email;
  final String password;
  final String provider;
  final String error;

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    String? provider,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      provider: provider ?? this.provider,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, email, password, provider, error];
}
