part of 'core_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

@immutable
abstract class CoreState {
  final AuthenticationStatus status;
  final User user;

  CoreState(
      {this.status = AuthenticationStatus.unknown, this.user = User.unknown});

  @override
  List<Object> get props => [status, user];
}

class CoreInitial extends CoreState {}
