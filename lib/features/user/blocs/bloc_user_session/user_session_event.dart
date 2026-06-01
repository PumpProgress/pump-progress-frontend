part of 'user_session_bloc.dart';

sealed class UserSessionEvent extends Equatable {
  const UserSessionEvent();

  @override
  List<Object?> get props => [];
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

class UserSessionUpdateProfileEvent extends UserSessionEvent {
  const UserSessionUpdateProfileEvent({
    this.age,
    this.gender,
    this.fitnessLevel,
    this.primaryGoal,
    this.trainingDaysPerWeek,
  });

  final int? age;
  final String? gender;
  final String? fitnessLevel;
  final String? primaryGoal;
  final int? trainingDaysPerWeek;

  @override
  List<Object?> get props =>
      [age, gender, fitnessLevel, primaryGoal, trainingDaysPerWeek];
}
