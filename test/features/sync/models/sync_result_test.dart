import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/sync/models/sync_result.dart';

void main() {
  group('SyncResult', () {
    test('hasData is false when both counts are zero', () {
      const result = SyncResult(totalReceived: 0, totalSent: 0);
      expect(result.hasData, false);
    });

    test('hasData is true when totalReceived > 0', () {
      const result = SyncResult(totalReceived: 5, totalSent: 0);
      expect(result.hasData, true);
    });

    test('hasData is true when totalSent > 0', () {
      const result = SyncResult(totalReceived: 0, totalSent: 3);
      expect(result.hasData, true);
    });

    test('hasData is true when both counts > 0', () {
      const result = SyncResult(totalReceived: 5, totalSent: 3);
      expect(result.hasData, true);
    });

    test('two instances with same values are equal', () {
      const a = SyncResult(totalReceived: 5, totalSent: 3);
      const b = SyncResult(totalReceived: 5, totalSent: 3);
      expect(a, equals(b));
    });

    test('two instances with different values are not equal', () {
      const a = SyncResult(totalReceived: 5, totalSent: 3);
      const b = SyncResult(totalReceived: 1, totalSent: 3);
      expect(a, isNot(equals(b)));
    });
  });

  group('SyncPostResult', () {
    test('holds sent and received counts', () {
      const r = SyncPostResult(sent: 2, received: 7);
      expect(r.sent, 2);
      expect(r.received, 7);
    });
  });
}
