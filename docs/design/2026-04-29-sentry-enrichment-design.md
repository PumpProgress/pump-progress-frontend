# Sentry Enrichment Design

**Date:** 2026-04-29  
**Branch:** feat/add-sentry-more-info  
**Status:** Approved

## Goal

Improve Sentry's ability to debug production errors by adding two capabilities:
1. Attach authenticated user identity to every Sentry event
2. Record all HTTP requests and responses as Sentry breadcrumbs so the full API call history is visible when an error occurs

## Scope

- `PumpProgressApiDio` — main app API client (Dio)
- `UsersPoolService` — Cognito OAuth/token-refresh client (Dio)
- `UserSessionBloc` — source of truth for authenticated user identity

No new packages. No changes to Sentry initialization in `bootstrap.dart`.

---

## Part 1: Sentry User Context

### What

When a user successfully authenticates, set the Sentry user scope so every subsequent event is tagged with their identity. Clear the scope on logout or auth failure.

### Where

`lib/features/user/blocs/bloc_user_session/user_session_bloc.dart`

### Behaviour

| Event | Action |
|---|---|
| `UserSessionStatusAuthenticated` emitted | `Sentry.configureScope` → set `SentryUser(id, email, username)` |
| `UserSessionStatusUnauthenticated` emitted (logout) | `Sentry.configureScope` → set user to `null` |
| catch block in `_onUserSessionInitEvent` | `Sentry.configureScope` → set user to `null` |

### Data sent to Sentry

```dart
SentryUser(
  id: user.id,
  email: user.email,
  username: user.name,
)
```

---

## Part 2: HTTP Breadcrumbs

### New file

`lib/utils/services/api_client_pp/sentry_dio_interceptor.dart`

A single `SentryDioInterceptor` class implementing Dio's `Interceptor`. No state. Reused by both Dio clients.

### Interceptor hooks

#### `onRequest`
Fires before every outgoing request. Adds a Sentry breadcrumb:

```
type:     "http"
category: "http.request"
level:    info
data:
  method:          "GET"
  url:             "https://..."
  queryParameters: { ... }
  headers:         { ... sanitized }
  body:            { ... } | null
```

#### `onResponse`
Fires on every successful response (2xx and non-2xx that don't throw). Adds a Sentry breadcrumb:

```
type:     "http"
category: "http.response"
level:    info  (warning if statusCode >= 400)
data:
  method:     "GET"
  url:        "https://..."
  statusCode: 200
  headers:    { ... sanitized }
  body:       { ... } | null
```

#### `onError`
Fires when Dio throws a `DioException`. Adds a Sentry breadcrumb with both request and response details combined. Does NOT call `captureException` — that is already done by `_ErrorLogInterceptor` in `PumpProgressApiDio`.

```
type:     "http"
category: "http.error"
level:    error
data:
  method:          "GET"
  url:             "https://..."
  statusCode:      500  (null if no response, e.g. timeout)
  requestHeaders:  { ... sanitized }
  requestBody:     { ... } | null
  responseHeaders: { ... sanitized } | null
  responseBody:    { ... } | null
  errorMessage:    "DioException [bad response]: ..."
```

### Header sanitization

Private `_sanitizeHeaders(Map<String, dynamic>? headers)`:
- Returns empty map if null
- For each key, if `key.toLowerCase()` contains any of: `authorization`, `x-id-token`, `cookie` → replace value with `"[REDACTED]"`
- All other headers pass through unchanged

### Body formatting

Private `_formatBody(dynamic body)`:
- `null` → `null`
- `Map` → returned as-is
- `String` → returned as-is (may be JSON, plain text, etc.)
- `FormData` → `{ "fields": [...], "files": [...filenames...] }` (no file content)
- Anything else → `body.toString()`

---

## Part 3: Wire-up

### `PumpProgressApiDio` (`lib/utils/services/api_client_pp/api_client_pp.dart`)

Add `SentryDioInterceptor()` as the **first** interceptor, before `_AuthInterceptor` and `_ErrorLogInterceptor`:

```dart
client.interceptors.addAll([
  SentryDioInterceptor(),   // new
  _AuthInterceptor(client, userPool),
  _ErrorLogInterceptor(),
]);
```

### `UsersPoolService` (`lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart`)

Add `SentryDioInterceptor()` as the first interceptor. Also activate the existing commented-out Sentry call in `_ErrorLogInterceptor` so Cognito errors are also captured:

```dart
client.interceptors.addAll([
  SentryDioInterceptor(),   // new
  _ErrorLogInterceptor(),
]);
```

And in `_ErrorLogInterceptor.onError` for this client, uncomment the `Sentry.captureException` call.

---

## Files Changed

| File | Change |
|---|---|
| `lib/utils/services/api_client_pp/sentry_dio_interceptor.dart` | **New** — `SentryDioInterceptor` class |
| `lib/utils/services/api_client_pp/api_client_pp.dart` | Add interceptor, update import |
| `lib/utils/services/cognito_user_pool/cognito_user_pool_client.dart` | Add interceptor, activate Sentry in error logger |
| `lib/features/user/blocs/bloc_user_session/user_session_bloc.dart` | Set/clear Sentry user context on auth events |

## Out of Scope

- Response body size limits (Sentry truncates large payloads automatically)
- Filtering which endpoints get breadcrumbs (all endpoints are included)
- Changes to `bootstrap.dart` Sentry initialization
- Any UI changes
