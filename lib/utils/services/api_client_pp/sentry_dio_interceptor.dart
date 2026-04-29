import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryDioInterceptor extends Interceptor {
  static const _sensitiveKeys = ['authorization', 'x-id-token', 'cookie'];

  @visibleForTesting
  static Map<String, dynamic> sanitizeHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return {};
    return headers.map((key, value) {
      final lower = key.toLowerCase();
      if (_sensitiveKeys.contains(lower)) {
        return MapEntry(key, '[REDACTED]');
      }
      return MapEntry(key, value);
    });
  }

  @visibleForTesting
  static dynamic formatBody(dynamic body) {
    if (body == null) return null;
    if (body is Map) return body;
    if (body is String) return body;
    if (body is FormData) {
      return {
        'fields': body.fields.map((e) => '${e.key}=${e.value}').toList(),
        'files': body.files.map((e) => e.key).toList(),
      };
    }
    return body.toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Sentry.addBreadcrumb(Breadcrumb(
      type: 'http',
      category: 'http.request',
      level: SentryLevel.info,
      data: {
        'method': options.method,
        'url': options.uri.toString(),
        'queryParameters': options.queryParameters,
        'headers': sanitizeHeaders(options.headers),
        'body': formatBody(options.data),
      },
    ));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    Sentry.addBreadcrumb(Breadcrumb(
      type: 'http',
      category: 'http.response',
      level: statusCode >= 400 ? SentryLevel.warning : SentryLevel.info,
      data: {
        'method': response.requestOptions.method,
        'url': response.requestOptions.uri.toString(),
        'statusCode': statusCode,
        'headers': sanitizeHeaders(
          response.headers.map.map((k, v) => MapEntry(k, v.join(', '))),
        ),
        'body': formatBody(response.data),
      },
    ));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Sentry.addBreadcrumb(Breadcrumb(
      type: 'http',
      category: 'http.error',
      level: SentryLevel.error,
      data: {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'statusCode': err.response?.statusCode,
        'requestHeaders': sanitizeHeaders(
          err.requestOptions.headers,
        ),
        'requestBody': formatBody(err.requestOptions.data),
        'responseHeaders': err.response != null
            ? sanitizeHeaders(
                err.response!.headers.map.map((k, v) => MapEntry(k, v.join(', '))),
              )
            : null,
        'responseBody':
            err.response != null ? formatBody(err.response!.data) : null,
        'errorMessage': err.toString(),
      },
    ));
    handler.next(err);
  }
}
