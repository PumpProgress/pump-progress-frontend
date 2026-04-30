// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sync_bloc.dart';

sealed class SyncBlocStatus extends Equatable {
  const SyncBlocStatus();
}
// initial, inProgress, success, failure

class SyncBlocStatusInitial extends SyncBlocStatus {
  const SyncBlocStatusInitial();

  @override
  List<Object> get props => [];
}

class SyncBlocStatusInProgress extends SyncBlocStatus {
  const SyncBlocStatusInProgress();

  @override
  List<Object> get props => [];
}

class SyncBlocStatusSuccess extends SyncBlocStatus {
  const SyncBlocStatusSuccess();

  @override
  List<Object> get props => [];
}

class SyncBlocStatusError extends ErrorStatus
    with EquatableMixin
    implements SyncBlocStatus {
  SyncBlocStatusError(super.error);

  @override
  List<Object> get props => [errorMsg];
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
