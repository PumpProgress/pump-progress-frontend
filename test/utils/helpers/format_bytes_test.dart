// test/utils/helpers/format_bytes_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/utils/helpers/format_bytes.dart';

void main() {
  group('formatBytes', () {
    test('zero bytes', () => expect(formatBytes(0), '0 B'));
    test('bytes', () => expect(formatBytes(512), '512 B'));
    test('kilobytes', () => expect(formatBytes(2048), '2.0 KB'));
    test('megabytes', () => expect(formatBytes(5 * 1024 * 1024), '5.0 MB'));
    test('gigabytes rounding', () {
      expect(formatBytes((3.2 * 1024 * 1024 * 1024).round()), '3.2 GB');
    });
  });
}
