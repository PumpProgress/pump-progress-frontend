// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sync_bloc.dart';

sealed class SyncBlocStatus extends Equatable {
  const SyncBlocStatus();
}

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

class SyncAttempt extends Equatable {
  const SyncAttempt({required this.timestamp, required this.success});
  final DateTime timestamp;
  final bool success;

  @override
  List<Object> get props => [timestamp, success];
}

class SyncState extends Equatable {
  const SyncState({
    this.status = const SyncBlocStatusInitial(),
    this.history = const [],
  });

  final SyncBlocStatus status;
  final List<SyncAttempt> history;

  @override
  List<Object> get props => [status, history];

  SyncState copyWith({
    SyncBlocStatus? status,
    List<SyncAttempt>? history,
  }) {
    return SyncState(
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }
}
