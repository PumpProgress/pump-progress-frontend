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
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];

  SyncBloc({required this.repositorySync}) : super(SyncState()) {
    on<StartSyncEvent>(_onStartSyncEvent);
    on<StartPeriodicSyncEvent>(_onStartPeriodicSyncEvent);
    on<StopPeriodicSyncEvent>(_onStopPeriodicSyncEvent);
  }

  Future<void> _onStartSyncEvent(
      StartSyncEvent event, Emitter<SyncState> emit) async {
    if (state.status is SyncBlocStatusInProgress) return;

    await runSafeEvent(emit, state, SyncBlocStatusError.new, () async {
      emit(state.copyWith(status: SyncBlocStatusInProgress()));
      await repositorySync.syncTables();
      emit(state.copyWith(
        status: SyncBlocStatusSuccess(),
        history: _appendAttempt(state.history, success: true),
      ));
    });

    if (state.status is SyncBlocStatusSuccess) {
      _consecutiveFailures = 0;
      // Resume periodic if it was paused during backoff
      if (_periodicTimer == null && _periodicInterval != null) {
        _startPeriodicTimer(_periodicInterval!);
      }
    } else if (state.status is SyncBlocStatusError) {
      // runSafeEvent already emitted the error status; now append history.
      emit(state.copyWith(
        history: _appendAttempt(state.history, success: false),
      ));
      if (_periodicInterval != null) {
        _consecutiveFailures++;
        _scheduleBackoffRetry();
      }
    }
  }

  void _onStartPeriodicSyncEvent(
      StartPeriodicSyncEvent event, Emitter<SyncState> emit) {
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    _periodicInterval = event.interval;
    _consecutiveFailures = 0;
    _startPeriodicTimer(event.interval);
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
    final index =
        (_consecutiveFailures - 1).clamp(0, _backoffDurations.length - 1);
    _retryTimer = Timer(_backoffDurations[index], () {
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
