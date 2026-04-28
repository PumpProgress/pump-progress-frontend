part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object> get props => [];
}

final class StartSyncEvent extends SyncEvent {
  const StartSyncEvent();
}
