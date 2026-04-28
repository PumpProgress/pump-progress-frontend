part of 'login_bloc.dart';

sealed class LoginStatus {
  const LoginStatus();
}

final class LoginStatusInitial extends LoginStatus {
  const LoginStatusInitial();
}

final class LoginStatusLoading extends LoginStatus {}

final class LoginStatusSuccess extends LoginStatus {}

final class LoginStatusProviderLogIn extends LoginStatus {}

final class LoginStatusProviderValidateToken extends LoginStatus {}

final class LoginStatusError extends ErrorStatus implements LoginStatus {
  LoginStatusError(super.errorMsg);
}

class LoginState extends Equatable {
  const LoginState({
    this.status = const LoginStatusInitial(),
    this.provider = '',
  });

  final LoginStatus status;
  final String provider;

  @override
  List<Object> get props => [status, provider];

  LoginState copyWith({
    LoginStatus? status,
    String? provider,
  }) {
    return LoginState(
      status: status ?? this.status,
      provider: provider ?? this.provider,
    );
  }
}
