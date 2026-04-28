part of 'user_session_bloc.dart';

sealed class UserSessionEvent extends Equatable {
  const UserSessionEvent();

  @override
  List<Object> get props => [];
}

class UserSessionInitEvent extends UserSessionEvent {
  const UserSessionInitEvent();
}

class UserSessionLogoutEvent extends UserSessionEvent {
  const UserSessionLogoutEvent();
}

class UserSessionDeleteAccountEvent extends UserSessionEvent {
  const UserSessionDeleteAccountEvent();
}
