part of 'core_bloc.dart';

@immutable
abstract class CoreEvent extends Equatable {
  const CoreEvent();

  @override
  List<Object> get props => [];
}

class CoreInit extends CoreEvent {
  const CoreInit();
}

class CoreLogout extends CoreEvent {
  const CoreLogout();
}

class CoreMeUpdated extends CoreEvent {
  const CoreMeUpdated({required this.me});
  final User me;
}
