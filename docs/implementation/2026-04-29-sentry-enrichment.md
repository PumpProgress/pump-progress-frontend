# Sentry Enrichment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Attach authenticated user identity and full HTTP request/response breadcrumbs to every Sentry event so production errors can be debugged with complete context.

**Architecture:** A new `SentryDioInterceptor` is added to both Dio clients (main API and Cognito); it logs every request, response, and error as a Sentry breadcrumb with sensitive headers redacted. `UserSessionBloc` sets the Sentry user scope on login and clears it on logout.

**Tech Stack:** Flutter/Dart, Dio 5.x, sentry_flutter 9.x, flutter_test

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| **Create** | `lib/utils/services/api_client_pp/sentry_dio_interceptor.dart` | `SentryDioInterceptor` class with all breadcrumb logic |
| **Create** | `test/utils/services/sentry_dio_interceptor_test.dart` | Unit tests for `sanitizeHeaders` and `formatBody` |
| **Modify** | `lib/utils/services/api_client_pp/api_client_pp.dart` | Wire `SentryDioInterceptor` into `PumpProgressApiDio` |
| **Modify** | `lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart` | Wire `SentryDioInterceptor` into `UsersPoolService`, activate Sentry in its error logger |
| **Modify** | `lib/features/user/blocs/bloc_user_session/user_session_bloc.dart` | Set/clear Sentry user context on auth events |

---

## Task 1: Create `SentryDioInterceptor` with tests

**Files:**
- Create: `lib/utils/services/api_client_pp/sentry_dio_interceptor.dart`
- Create: `test/utils/services/sentry_dio_interceptor_test.dart`

- [ ] **Step 1: Create the test file**

Create `test/utils/services/sentry_dio_interceptor_test.dart` with the following content. These tests cover the two pure helper methods — `sanitizeHeaders` and `formatBody` — which are exposed as `@visibleForTesting` static methods so they can be reached from the test package.

```dart
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
  });
}
```

- [ ] **Step 2: Run the tests and confirm they fail**

```bash
fvm flutter test test/utils/services/sentry_dio_interceptor_test.dart
```

Expected: compilation failure — `sentry_dio_interceptor.dart` does not exist yet.

- [ ] **Step 3: Create `sentry_dio_interceptor.dart`**

Create `lib/utils/services/api_client_pp/sentry_dio_interceptor.dart`:

```dart
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
      if (_sensitiveKeys.any((k) => lower.contains(k))) {
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
        'headers': sanitizeHeaders(options.headers.cast<String, dynamic>()),
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
          response.headers.map.cast<String, dynamic>(),
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
          err.requestOptions.headers.cast<String, dynamic>(),
        ),
        'requestBody': formatBody(err.requestOptions.data),
        'responseHeaders': err.response != null
            ? sanitizeHeaders(
                err.response!.headers.map.cast<String, dynamic>(),
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
```

- [ ] **Step 4: Run the tests and confirm they pass**

```bash
fvm flutter test test/utils/services/sentry_dio_interceptor_test.dart
```

Expected output:
```
00:XX +12: All tests passed!
```

- [ ] **Step 5: Run the analyzer**

```bash
fvm flutter analyze lib/utils/services/api_client_pp/sentry_dio_interceptor.dart
```

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/utils/services/api_client_pp/sentry_dio_interceptor.dart test/utils/services/sentry_dio_interceptor_test.dart
git commit -m "feat: add SentryDioInterceptor with HTTP breadcrumb logging"
```

---

## Task 2: Wire `SentryDioInterceptor` into `PumpProgressApiDio`

**Files:**
- Modify: `lib/utils/services/api_client_pp/api_client_pp.dart`

The current interceptor list in `PumpProgressApiDio._internal()` is:
```dart
client.interceptors.addAll([
  _AuthInterceptor(client, userPool),
  _ErrorLogInterceptor(),
]);
```

- [ ] **Step 1: Add the import and interceptor**

Open `lib/utils/services/api_client_pp/api_client_pp.dart`. Add the import at the top with the other imports:

```dart
import 'package:pump_progress_frontend/utils/services/api_client_pp/sentry_dio_interceptor.dart';
```

Then update the interceptors list in `PumpProgressApiDio._internal()`:

```dart
client.interceptors.addAll([
  SentryDioInterceptor(),
  _AuthInterceptor(client, userPool),
  _ErrorLogInterceptor(),
]);
```

- [ ] **Step 2: Run the analyzer**

```bash
fvm flutter analyze lib/utils/services/api_client_pp/api_client_pp.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/utils/services/api_client_pp/api_client_pp.dart
git commit -m "feat: wire SentryDioInterceptor into PumpProgressApiDio"
```

---

## Task 3: Wire `SentryDioInterceptor` into `UsersPoolService` and activate its error logger

**Files:**
- Modify: `lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart`

The current file (`cognito_user_pool_client.dart`) is a `part of` file. The `_ErrorLogInterceptor` there only prints and has the `Sentry.captureException` call commented out.

- [ ] **Step 1: Add imports to the parent library file**

`cognito_user_pool_client.dart` is a `part of` file — its imports live in the parent. Open `lib/utils/services/cognito_user_pool/cognito_user_pool.dart`. It currently contains only one import (`package:dio/dio.dart`). Update the file so it looks exactly like this:

```dart
import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/utils/services/api_client_pp/sentry_dio_interceptor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'cognito_user_pool_client.dart';
```

- [ ] **Step 2: Update `_ErrorLogInterceptor.onError` in the Cognito client**

In `lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart`, replace the current `_ErrorLogInterceptor`:

```dart
// BEFORE:
class _ErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    print(error);
    // final hint = Hint();
    // Sentry.captureException(error, stackTrace: error.stackTrace, hint: hint);
    super.onError(error, handler);
  }
}
```

```dart
// AFTER:
class _ErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    Sentry.captureException(error, stackTrace: error.stackTrace);
    super.onError(error, handler);
  }
}
```

- [ ] **Step 3: Wire `SentryDioInterceptor` into `UsersPoolService._internal()`**

In `lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart`, update the interceptors:

```dart
// BEFORE:
client.interceptors.addAll([
  _ErrorLogInterceptor(),
]);
```

```dart
// AFTER:
client.interceptors.addAll([
  SentryDioInterceptor(),
  _ErrorLogInterceptor(),
]);
```

- [ ] **Step 4: Run the analyzer**

```bash
fvm flutter analyze lib/utils/services/cognito_user_pool/
```

Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart
git commit -m "feat: wire SentryDioInterceptor into UsersPoolService and activate error capture"
```

---

## Task 4: Set and clear Sentry user context in `UserSessionBloc`

**Files:**
- Modify: `lib/features/user/blocs/bloc_user_session/user_session_bloc.dart`

The current `_onUserSessionInitEvent` emits `UserSessionStatusAuthenticated` and sets `user` in state, but never tells Sentry who the user is. The `_onUserSessionLogoutEvent` clears local storage but doesn't clear the Sentry scope.

- [ ] **Step 1: Add the Sentry import**

Open `lib/features/user/blocs/bloc_user_session/user_session_bloc.dart`. Add the import (keep it sorted with existing imports):

```dart
import 'package:sentry_flutter/sentry_flutter.dart';
```

- [ ] **Step 2: Set user context after successful authentication**

In `_onUserSessionInitEvent`, after the line `emit(state.copyWith(status: const UserSessionStatusAuthenticated(), user: user,))`, add:

```dart
await Sentry.configureScope(
  (scope) => scope.setUser(
    SentryUser(
      id: user.id,
      email: user.email,
      username: user.name,
    ),
  ),
);
```

The updated method body (inside `runSafeEvent`) should look like this in full:

```dart
emit(state.copyWith(status: const UserSessionStatusLoading()));

final accessToken = prefs.getString(accessTokenKey);
final refreshToken = prefs.getString(refreshTokenKey);
final idToken = prefs.getString(idTokenKey);

if (accessToken == null || refreshToken == null || idToken == null) {
  emit(state.copyWith(status: const UserSessionStatusUnauthenticated()));
  return;
}

final userId = CognitoAccessToken(accessToken).payload['custom:userID'];
final user = await repositoryUser.getUser(userId);

emit(
  state.copyWith(
    status: const UserSessionStatusAuthenticated(),
    user: user,
  ),
);

await Sentry.configureScope(
  (scope) => scope.setUser(
    SentryUser(
      id: user.id,
      email: user.email,
      username: user.name,
    ),
  ),
);
```

- [ ] **Step 3: Clear user context on auth failure**

Still in `_onUserSessionInitEvent`, the outer `try/catch` (inside `runSafeEvent`'s own wrapper) rethrows after calling `_clearLocalStorage`. Add a Sentry scope clear in the `catch` block:

```dart
} catch (e) {
  _clearLocalStorage(prefs);
  await Sentry.configureScope((scope) => scope.setUser(null));
  rethrow;
}
```

- [ ] **Step 4: Clear user context on logout**

In `_onUserSessionLogoutEvent`, after `emit(state.copyWith(status: const UserSessionStatusUnauthenticated()))`, add:

```dart
await Sentry.configureScope((scope) => scope.setUser(null));
```

The full updated method:

```dart
Future<void> _onUserSessionLogoutEvent(
    UserSessionLogoutEvent event, Emitter<UserSessionState> emit) async {
  await runSafeEvent(emit, state, UserSessionStatusError.new, () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _clearLocalStorage(prefs);
    emit(state.copyWith(status: const UserSessionStatusUnauthenticated()));
    await Sentry.configureScope((scope) => scope.setUser(null));
  });
}
```

- [ ] **Step 5: Run the analyzer**

```bash
fvm flutter analyze lib/features/user/blocs/bloc_user_session/
```

Expected: `No issues found!`

- [ ] **Step 6: Run all tests**

```bash
fvm flutter test
```

Expected: all tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/features/user/blocs/bloc_user_session/user_session_bloc.dart
git commit -m "feat: set and clear Sentry user context on auth events"
```

---

## Final Verification

- [ ] **Run full analyzer**

```bash
fvm flutter analyze
```

Expected: `No issues found!`

- [ ] **Run all tests**

```bash
fvm flutter test
```

Expected: all tests pass.
