import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/sync/blocs/bloc_sync/sync_bloc.dart';

void main() {
  test('StartPeriodicSyncEvent has default interval of 5 minutes', () {
    const event = StartPeriodicSyncEvent();
    expect(event.interval, const Duration(minutes: 5));
  });

  test('StopPeriodicSyncEvent can be instantiated', () {
    const event = StopPeriodicSyncEvent();
    expect(event, isA<SyncEvent>());
  });
}
