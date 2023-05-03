part of 'core_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

@immutable
class CoreState extends Equatable {
  const CoreState({
    this.status = AuthenticationStatus.unknown,
    this.user = User.unknown,
  });

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];

  CoreState copyWith({
    AuthenticationStatus? status,
    User? user,
  }) {
    return CoreState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
