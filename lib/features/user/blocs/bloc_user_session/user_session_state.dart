part of 'user_session_bloc.dart';

sealed class UserSessionStatus {
  const UserSessionStatus();
}

class UserSessionStatusLoading implements UserSessionStatus {
  const UserSessionStatusLoading();
}

class UserSessionStatusAuthenticated implements UserSessionStatus {
  const UserSessionStatusAuthenticated();
}

class UserSessionStatusUnauthenticated implements UserSessionStatus {
  const UserSessionStatusUnauthenticated();
}

class UserSessionStatusError extends ErrorStatus implements UserSessionStatus {
  UserSessionStatusError(super.error);
}

class UserSessionState extends Equatable {
  const UserSessionState({
    this.status = const UserSessionStatusUnauthenticated(),
    this.user = User.unknown,
  });

  final UserSessionStatus status;
  final User user;
  @override
  List<Object> get props => [status, user];

  UserSessionState copyWith({
    UserSessionStatus? status,
    User? user,
  }) {
    return UserSessionState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
