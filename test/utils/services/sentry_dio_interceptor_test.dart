import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/utils/services/api_client_pp/sentry_dio_interceptor.dart';

void main() {
  group('SentryDioInterceptor.sanitizeHeaders', () {
    test('returns empty map when headers is null', () {
      expect(SentryDioInterceptor.sanitizeHeaders(null), isEmpty);
    });

    test('redacts Authorization header', () {
      final result = SentryDioInterceptor.sanitizeHeaders({
        'Authorization': 'Bearer abc123',
        'Content-Type': 'application/json',
      });
      expect(result['Authorization'], '[REDACTED]');
      expect(result['Content-Type'], 'application/json');
    });

    test('redacts authorization header case-insensitively', () {
      final result = SentryDioInterceptor.sanitizeHeaders({
        'AUTHORIZATION': 'Bearer abc123',
      });
      expect(result['AUTHORIZATION'], '[REDACTED]');
    });

    test('redacts X-ID-Token header', () {
      final result = SentryDioInterceptor.sanitizeHeaders({
        'X-ID-Token': 'token123',
        'Accept': 'application/json',
      });
      expect(result['X-ID-Token'], '[REDACTED]');
      expect(result['Accept'], 'application/json');
    });

    test('redacts cookie header', () {
      final result = SentryDioInterceptor.sanitizeHeaders({
        'Cookie': 'session=abc',
      });
      expect(result['Cookie'], '[REDACTED]');
    });

    test('passes through non-sensitive headers unchanged', () {
      final result = SentryDioInterceptor.sanitizeHeaders({
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'X-Request-Id': 'abc-123',
      });
      expect(result['Content-Type'], 'application/json');
      expect(result['Accept'], '*/*');
      expect(result['X-Request-Id'], 'abc-123');
    });

    test('returns empty map when headers map is empty', () {
      expect(SentryDioInterceptor.sanitizeHeaders({}), isEmpty);
    });
  });

  group('SentryDioInterceptor.formatBody', () {
    test('returns null when body is null', () {
      expect(SentryDioInterceptor.formatBody(null), isNull);
    });

    test('returns Map as-is', () {
      final body = {'userId': '123', 'name': 'Sergio'};
      expect(SentryDioInterceptor.formatBody(body), same(body));
    });

    test('returns String as-is', () {
      expect(SentryDioInterceptor.formatBody('{"key":"val"}'), '{"key":"val"}');
    });

    test('calls toString on unknown types', () {
      expect(SentryDioInterceptor.formatBody(42), '42');
      expect(SentryDioInterceptor.formatBody(true), 'true');
    });

    test('formats FormData into fields and file names', () {
      final form = FormData.fromMap({'username': 'sergio'});
      final result = SentryDioInterceptor.formatBody(form) as Map;
      expect(result['fields'], isA<List>());
      expect(result['files'], isA<List>());
      expect((result['fields'] as List).first, contains('username'));
    });
  });
}
