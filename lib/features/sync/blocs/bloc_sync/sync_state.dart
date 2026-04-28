// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sync_bloc.dart';

sealed class SyncBlocStatus {
  const SyncBlocStatus();
}
// initial, inProgress, success, failure

class SyncBlocStatusInitial extends SyncBlocStatus {
  const SyncBlocStatusInitial();
}

class SyncBlocStatusInProgress extends SyncBlocStatus {
  const SyncBlocStatusInProgress();
}

class SyncBlocStatusSuccess extends SyncBlocStatus {
  const SyncBlocStatusSuccess();
}

class SyncBlocStatusError extends ErrorStatus implements SyncBlocStatus {
  SyncBlocStatusError(super.error);
}

class SyncState extends Equatable {
  const SyncState({this.status = const SyncBlocStatusInitial()});

  final SyncBlocStatus status;

  @override
  List<Object> get props => [status];

  SyncState copyWith({
    SyncBlocStatus? status,
  }) {
    return SyncState(
      status: status ?? this.status,
    );
  }
}
