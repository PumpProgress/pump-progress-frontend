import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/settings/domain/format_app_version.dart';

void main() {
  group('formatAppVersion', () {
    test('formats version and build as "version (build)"', () {
      expect(formatAppVersion('4.1.0', '29'), '4.1.0 (29)');
    });

    test('omits build number when empty', () {
      expect(formatAppVersion('4.1.0', ''), '4.1.0');
    });
  });
}
