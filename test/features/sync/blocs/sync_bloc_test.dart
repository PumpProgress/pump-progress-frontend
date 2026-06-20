import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/sync/blocs/bloc_sync/sync_bloc.dart';
import 'package:pump_progress_frontend/features/sync/models/sync_result.dart';
import 'package:pump_progress_frontend/features/sync/repository/repository_sync.dart';

class MockRepositorySync extends Mock implements RepositorySync {}

void main() {
  late MockRepositorySync mockRepo;

  setUp(() {
    mockRepo = MockRepositorySync();
  });

  group('SyncAttempt', () {
    test('success attempt has correct fields', () {
      final attempt = SyncAttempt(timestamp: DateTime(2026, 5, 6, 14, 32), success: true);
      expect(attempt.success, true);
      expect(attempt.timestamp, DateTime(2026, 5, 6, 14, 32));
    });

    test('two attempts with same fields are equal', () {
      final t = DateTime(2026, 5, 6, 14, 32);
      final a = SyncAttempt(timestamp: t, success: true);
      final b = SyncAttempt(timestamp: t, success: true);
      expect(a, equals(b));
    });

    test('SyncState defaults to empty history', () {
      const s = SyncState();
      expect(s.history, isEmpty);
    });

    test('SyncState.copyWith preserves history when not overridden', () {
      final attempt = SyncAttempt(timestamp: DateTime(2026, 5, 6), success: true);
      final s = SyncState(history: [attempt]);
      final updated = s.copyWith(status: SyncBlocStatusInProgress());
      expect(updated.history, [attempt]);
    });

    test('SyncState equality includes history', () {
      final attempt = SyncAttempt(timestamp: DateTime(2026, 5, 6), success: true);
      final a = SyncState(history: [attempt]);
      final b = SyncState(history: [attempt]);
      expect(a, equals(b));
      const c = SyncState();
      expect(a, isNot(equals(c)));
    });
  });

  // ─── SyncBloc history recording ──────────────────────────────────────────

  group('SyncBloc history recording', () {
    blocTest<SyncBloc, SyncState>(
      'appends success attempt on manual sync success',
      build: () {
        when(() => mockRepo.syncTables()).thenAnswer(
          (_) async => const SyncResult(totalReceived: 0, totalSent: 0),
        );
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) => bloc.add(const StartSyncEvent()),
      verify: (bloc) {
        expect(bloc.state.history.length, 1);
        expect(bloc.state.history.last.success, true);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'appends failure attempt on manual sync error',
      build: () {
        when(() => mockRepo.syncTables()).thenThrow(Exception('fail'));
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) => bloc.add(const StartSyncEvent()),
      verify: (bloc) {
        expect(bloc.state.history.length, 1);
        expect(bloc.state.history.last.success, false);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'accumulates history across multiple syncs',
      build: () {
        var count = 0;
        when(() => mockRepo.syncTables()).thenAnswer((_) async {
          count++;
          if (count == 2) throw Exception('transient');
          return const SyncResult(totalReceived: 0, totalSent: 0);
        });
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) async {
        bloc.add(const StartSyncEvent());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const StartSyncEvent());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const StartSyncEvent());
        await Future<void>.delayed(Duration.zero);
      },
      verify: (bloc) {
        expect(bloc.state.history.length, 3);
        expect(bloc.state.history[0].success, true);
        expect(bloc.state.history[1].success, false);
        expect(bloc.state.history[2].success, true);
      },
    );

    blocTest<SyncBloc, SyncState>(
      'history caps at 50 entries',
      build: () {
        when(() => mockRepo.syncTables()).thenAnswer(
          (_) async => const SyncResult(totalReceived: 0, totalSent: 0),
        );
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) async {
        for (var i = 0; i < 51; i++) {
          bloc.add(const StartSyncEvent());
          await Future<void>.delayed(Duration.zero);
        }
      },
      verify: (bloc) {
        expect(bloc.state.history.length, 50);
      },
    );
  });

  // ─── StartSyncEvent ───────────────────────────────────────────────────────

  group('StartSyncEvent', () {
    blocTest<SyncBloc, SyncState>(
      'emits [InProgress, Success+history] on successful sync',
      build: () {
        when(() => mockRepo.syncTables()).thenAnswer(
          (_) async => const SyncResult(totalReceived: 0, totalSent: 0),
        );
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) => bloc.add(const StartSyncEvent()),
      expect: () => [
        SyncState(status: SyncBlocStatusInProgress()),
        isA<SyncState>()
            .having((s) => s.status, 'status', isA<SyncBlocStatusSuccess>())
            .having((s) => s.history.length, 'history length', 1)
            .having((s) => s.history.last.success, 'success', true),
      ],
    );

    blocTest<SyncBloc, SyncState>(
      'emits [InProgress, Error, Error+history] when syncTables throws',
      build: () {
        when(() => mockRepo.syncTables()).thenThrow(Exception('network error'));
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) => bloc.add(const StartSyncEvent()),
      expect: () => [
        SyncState(status: SyncBlocStatusInProgress()),
        isA<SyncState>().having(
          (s) => s.status,
          'status',
          isA<SyncBlocStatusError>(),
        ),
        isA<SyncState>()
            .having((s) => s.status, 'status', isA<SyncBlocStatusError>())
            .having((s) => s.history.length, 'history length', 1)
            .having((s) => s.history.last.success, 'success', false),
      ],
    );

    blocTest<SyncBloc, SyncState>(
      'does nothing when a sync is already in progress (de-dup)',
      build: () {
        final completer = Completer<SyncResult>();
        when(() => mockRepo.syncTables()).thenAnswer((_) => completer.future);
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) async {
        bloc.add(const StartSyncEvent()); // starts, stays InProgress
        await Future<void>.delayed(Duration.zero); // let the event start
        bloc.add(const StartSyncEvent()); // should be ignored
      },
      expect: () => [
        SyncState(status: SyncBlocStatusInProgress()),
        // No second InProgress — de-dup worked
      ],
    );

    test('close() while sync in progress does not throw', () async {
      final completer = Completer<SyncResult>();
      when(() => mockRepo.syncTables()).thenAnswer((_) => completer.future);
      final bloc = SyncBloc(repositorySync: mockRepo);
      bloc.add(const StartSyncEvent());
      await Future<void>.delayed(Duration.zero); // let the event start
      // close() before syncTables() completes — must not throw
      await expectLater(bloc.close(), completes);
    });

    blocTest<SyncBloc, SyncState>(
      'SyncBlocStatusSuccess carries the SyncResult returned by syncTables',
      build: () {
        when(() => mockRepo.syncTables()).thenAnswer(
          (_) async => const SyncResult(totalReceived: 5, totalSent: 3),
        );
        return SyncBloc(repositorySync: mockRepo);
      },
      act: (bloc) => bloc.add(const StartSyncEvent()),
      verify: (bloc) {
        final status = bloc.state.status as SyncBlocStatusSuccess;
        expect(status.result.totalReceived, 5);
        expect(status.result.totalSent, 3);
      },
    );
  });

  // ─── StartPeriodicSyncEvent ───────────────────────────────────────────────

  // group('StartPeriodicSyncEvent', () {
  //   test('default interval is 5 minutes', () {
  //     const event = StartPeriodicSyncEvent();
  //     expect(event.interval, const Duration(minutes: 5));
  //   });

  //   test('timer fires StartSyncEvent after one interval', () {
  //     fakeAsync((async) {
  //       when(() => mockRepo.syncTables()).thenAnswer((_) async {});
  //       final bloc = SyncBloc(repositorySync: mockRepo);
  //       bloc.add(const StartPeriodicSyncEvent(interval: Duration(seconds: 10)));

  //       async.elapse(const Duration(seconds: 10));
  //       async.flushMicrotasks();

  //       verify(() => mockRepo.syncTables()).called(1);
  //       bloc.close();
  //     });
  //   });

  //   test('second StartPeriodicSyncEvent replaces previous timer', () {
  //     fakeAsync((async) {
  //       when(() => mockRepo.syncTables()).thenAnswer((_) async {});
  //       final bloc = SyncBloc(repositorySync: mockRepo);
  //       bloc.add(const StartPeriodicSyncEvent(interval: Duration(seconds: 10)));
  //       bloc.add(const StartPeriodicSyncEvent(interval: Duration(seconds: 30)));

  //       // 10s timer was replaced — should NOT fire at 10s
  //       async.elapse(const Duration(seconds: 10));
  //       async.flushMicrotasks();
  //       verifyNever(() => mockRepo.syncTables());

  //       // 30s timer fires
  //       async.elapse(const Duration(seconds: 20));
  //       async.flushMicrotasks();
  //       verify(() => mockRepo.syncTables()).called(1);

  //       bloc.close();
  //     });
  //   });

  //   test('does not start a new sync tick when one is InProgress', () {
  //     fakeAsync((async) {
  //       final completer = Completer<void>();
  //       when(() => mockRepo.syncTables())
  //           .thenAnswer((_) => completer.future);
  //       final bloc = SyncBloc(repositorySync: mockRepo);
  //       bloc.add(const StartSyncEvent()); // force InProgress
  //       bloc.add(const StartPeriodicSyncEvent(interval: Duration(seconds: 5)));

  //       async.elapse(const Duration(seconds: 5));
  //       async.flushMicrotasks();

  //       // syncTables was called once (from the manual StartSyncEvent), not twice
  //       verify(() => mockRepo.syncTables()).called(1);

  //       bloc.close();
  //     });
  //   });
  // });

  // ─── StopPeriodicSyncEvent ────────────────────────────────────────────────

  group('StopPeriodicSyncEvent', () {
    test('cancels timer so no further syncs fire', () {
      fakeAsync((async) {
        when(() => mockRepo.syncTables()).thenAnswer(
          (_) async => const SyncResult(totalReceived: 0, totalSent: 0),
        );
        final bloc = SyncBloc(repositorySync: mockRepo);
        bloc.add(const StartPeriodicSyncEvent(interval: Duration(seconds: 5)));
        bloc.add(const StopPeriodicSyncEvent());

        async.elapse(const Duration(seconds: 20));
        async.flushTimers();

        verifyNever(() => mockRepo.syncTables());
        bloc.close();
      });
    });

    test('cancels backoff retry timer when stopped during backoff', () {
      fakeAsync((async) {
        var callCount = 0;
        when(() => mockRepo.syncTables()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) throw Exception('fail');
          return const SyncResult(totalReceived: 0, totalSent: 0);
        });

        final bloc = SyncBloc(repositorySync: mockRepo);
        bloc.add(const StartPeriodicSyncEvent(interval: Duration(minutes: 5)));

        // First tick → fails → schedules 2-minute backoff retry
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();
        expect(callCount, 1);

        // Stop sync while in backoff (before retry fires)
        bloc.add(const StopPeriodicSyncEvent());
        async.flushMicrotasks();

        // Advance past the backoff duration — retry must NOT fire
        async.elapse(const Duration(minutes: 2));
        async.flushMicrotasks();
        expect(callCount, 1); // no retry fired

        bloc.close();
      });
    });
  });

  // ─── Backoff retry ────────────────────────────────────────────────────────

  group('Backoff retry', () {
    test('first failure schedules 2-minute retry', () {
      fakeAsync((async) {
        when(() => mockRepo.syncTables()).thenThrow(Exception('fail'));
        final bloc = SyncBloc(repositorySync: mockRepo);
        bloc.add(const StartPeriodicSyncEvent(interval: Duration(minutes: 5)));

        // Trigger first tick
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();

        // syncTables called once (from tick), failed
        verify(() => mockRepo.syncTables()).called(1);

        // Periodic timer was cancelled; retry fires in 2m
        async.elapse(const Duration(minutes: 2));
        async.flushMicrotasks();

        verify(() => mockRepo.syncTables()).called(1); // called again for retry
        bloc.close();
      });
    });

    test('successful retry resumes periodic timer', () {
      fakeAsync((async) {
        var callCount = 0;
        when(() => mockRepo.syncTables()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) throw Exception('transient');
          // subsequent calls succeed
          return const SyncResult(totalReceived: 0, totalSent: 0);
        });

        final bloc = SyncBloc(repositorySync: mockRepo);
        bloc.add(const StartPeriodicSyncEvent(interval: Duration(minutes: 5)));

        // First tick → fails
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();

        // Backoff retry (2m) → succeeds, periodic should restart
        async.elapse(const Duration(minutes: 2));
        async.flushMicrotasks();

        // Now the periodic timer is running again; next 5-min tick fires
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();

        expect(callCount, 3); // initial tick + retry + resumed periodic tick
        bloc.close();
      });
    });

    test('consecutive failures cap backoff at 16 minutes', () {
      fakeAsync((async) {
        var callCount = 0;
        when(() => mockRepo.syncTables()).thenAnswer((_) async {
          callCount++;
          throw Exception('always fails');
        });

        final bloc = SyncBloc(repositorySync: mockRepo);
        bloc.add(const StartPeriodicSyncEvent(interval: Duration(minutes: 5)));

        // 1st tick → fail → retry in 2m
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();
        expect(callCount, 1);

        // retry 1 → fail → retry in 4m
        async.elapse(const Duration(minutes: 2));
        async.flushMicrotasks();
        expect(callCount, 2);

        // retry 2 → fail → retry in 8m
        async.elapse(const Duration(minutes: 4));
        async.flushMicrotasks();
        expect(callCount, 3);

        // retry 3 → fail → retry in 16m
        async.elapse(const Duration(minutes: 8));
        async.flushMicrotasks();
        expect(callCount, 4);

        // retry 4 → fail → retry in 16m (capped, not longer)
        async.elapse(const Duration(minutes: 16));
        async.flushMicrotasks();
        expect(callCount, 5);

        // retry 5 → fail → retry still in 16m (not out-of-bounds)
        async.elapse(const Duration(minutes: 16));
        async.flushMicrotasks();
        expect(callCount, 6);

        bloc.close();
      });
    });
  });
}
