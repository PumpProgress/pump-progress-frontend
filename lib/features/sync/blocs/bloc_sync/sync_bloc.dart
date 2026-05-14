import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/sync/repository/repository_sync.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final RepositorySync repositorySync;

  Timer? _periodicTimer;
  Timer? _retryTimer;
  Duration? _periodicInterval;
  int _consecutiveFailures = 0;

  static const List<Duration> _backoffDurations = [
    Duration(minutes: 2),
    Duration(minutes: 4),
    Duration(minutes: 8),
    Duration(minutes: 16),
  ];

  SyncBloc({required this.repositorySync}) : super(SyncState()) {
    on<StartSyncEvent>(_onStartSyncEvent);
    on<StartPeriodicSyncEvent>(_onStartPeriodicSyncEvent);
    on<StopPeriodicSyncEvent>(_onStopPeriodicSyncEvent);
  }

  Future<void> _onStartSyncEvent(
      StartSyncEvent event, Emitter<SyncState> emit) async {
    if (state.status is SyncBlocStatusInProgress) return;

    var syncFailed = false;
    await runSafeEvent(emit, () => state, SyncBlocStatusError.new, () async {
      emit(state.copyWith(status: SyncBlocStatusInProgress()));
      try {
        await repositorySync.syncTables();
        _consecutiveFailures = 0;
        emit(state.copyWith(
          status: SyncBlocStatusSuccess(),
          history: _appendAttempt(state.history, success: true),
        ));
        if (_periodicTimer == null && _periodicInterval != null) {
          _startPeriodicTimer(_periodicInterval!);
        }
      } catch (e) {
        syncFailed = true;
        if (_periodicInterval != null) {
          _consecutiveFailures++;
          _scheduleBackoffRetry();
        }
        rethrow;
      }
    });

    if (syncFailed) {
      emit(state.copyWith(
        history: _appendAttempt(state.history, success: false),
      ));
    }
  }

  Duration _getNextInterval() {
    final index =
        (_consecutiveFailures - 1).clamp(0, _backoffDurations.length - 1);
    return _backoffDurations[index];
  }

  void _onStartPeriodicSyncEvent(
      StartPeriodicSyncEvent event, Emitter<SyncState> emit) {
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    _periodicInterval = event.interval ?? _getNextInterval();
    _consecutiveFailures = 0;
    _startPeriodicTimer(_periodicInterval!);
  }

  void _onStopPeriodicSyncEvent(
      StopPeriodicSyncEvent event, Emitter<SyncState> emit) {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _retryTimer?.cancel();
    _retryTimer = null;
    _periodicInterval = null;
    _consecutiveFailures = 0;
  }

  void _startPeriodicTimer(Duration interval) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (_) {
      if (state.status is! SyncBlocStatusInProgress) {
        add(const StartSyncEvent());
      }
    });
  }

  void _scheduleBackoffRetry() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _retryTimer?.cancel();
    final nextInterval = _getNextInterval();

    _retryTimer = Timer(nextInterval, () {
      _retryTimer = null;
      add(const StartSyncEvent());
    });
  }

  List<SyncAttempt> _appendAttempt(
    List<SyncAttempt> history, {
    required bool success,
  }) {
    final next = [
      ...history,
      SyncAttempt(timestamp: DateTime.now(), success: success),
    ];
    return next.length > 50 ? next.sublist(next.length - 50) : next;
  }

  @override
  Future<void> close() {
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    return super.close();
  }
}
