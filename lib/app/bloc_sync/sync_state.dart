part of 'sync_bloc.dart';

enum SyncStatus { initial, inProgress, success, failure }

class SyncState extends Equatable {
  const SyncState({this.status = SyncStatus.initial});

  final SyncStatus status;

  @override
  List<Object> get props => [status];
}
