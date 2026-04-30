part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object> get props => [];
}

final class StartSyncEvent extends SyncEvent {
  const StartSyncEvent();
}

final class StartPeriodicSyncEvent extends SyncEvent {
  const StartPeriodicSyncEvent({this.interval = const Duration(minutes: 5)});
  final Duration interval;

  @override
  List<Object> get props => [interval];
}

final class StopPeriodicSyncEvent extends SyncEvent {
  const StopPeriodicSyncEvent();
}
