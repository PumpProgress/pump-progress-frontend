part of 'core_bloc.dart';

@immutable
abstract class CoreEvent extends Equatable {
  const CoreEvent();

  @override
  List<Object> get props => [];
}

class CoreInit extends CoreEvent {
  const CoreInit();

  @override
  List<Object> get props => [];
}

class CoreLogout extends CoreEvent {
  const CoreLogout();

  @override
  List<Object> get props => [];
}
