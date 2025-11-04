part of 'pump_progress_api_provider.dart';

class _AuthInterceptor extends Interceptor {
  late Dio client;
  late PPUserPool userPool;

  _AuthInterceptor(Dio client, Dio userPool) {
    client = client;
    userPool = userPool;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (options.method.toUpperCase() == 'OPTIONS') {
        handler.next(options);
        return;
      }

      final accessToken = prefs.getString(accessTokenKey);
      final tokenId = prefs.getString(idTokenKey);

      if (accessToken == null ||
          accessToken.isEmpty ||
          tokenId == null ||
          tokenId.isEmpty) {
        handler.next(options);
        return;
      }
      options.headers.addEntries([
        MapEntry<String, String>('Authorization', 'Bearer $accessToken'),
        MapEntry<String, String>('X-ID-Token', tokenId)
      ]);
    } catch (e) {
      print('no auth token');
    }
    return handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    try {
      if (error.response?.statusCode == 401 &&
          !error.requestOptions.headers.containsKey('X-Avoid-Retry')) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString(refreshTokenKey);
        if (refreshToken == null) {
          handler.next(error);
          return;
        }
        error.requestOptions.headers['X-Avoid-Retry'] = 'true';

        final session = await userPool.renewCognitoTokens(refreshToken);

        final newAccessToken = session.accessToken.jwtToken;
        final newIdToken = session.idToken.jwtToken;

        prefs.setString(accessTokenKey, newAccessToken!);
        prefs.setString(idTokenKey, newIdToken!);

        error.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
        error.requestOptions.headers['X-ID-Token'] = newIdToken;

        final response = await client.request(
          error.requestOptions.path,
          options: Options(
            method: error.requestOptions.method,
            headers: error.requestOptions.headers,
          ),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
        );

        handler.resolve(response);
        return;
      }
    } catch (e) {
      return;
    }
    handler.next(error);
  }
}

class _ErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    // print request debug
    print(error.requestOptions);
    print(error);
    print("error interceptor !!!");
    Sentry.captureException(error, stackTrace: error.stackTrace);
    super.onError(error, handler);
  }
}

class PumpProgressApiDio {
  late Dio client;
  static final PumpProgressApiDio _singleton = PumpProgressApiDio._internal();

  factory PumpProgressApiDio() {
    return _singleton;
  }
  PumpProgressApiDio._internal() {
    final userPool = PPUserPool();
    final options = BaseOptions(
      baseUrl: FlavorConfig.baseUrl,
    );
    client = Dio(options);
    client.interceptors.addAll([
      _AuthInterceptor(client, userPool.client),
      _ErrorLogInterceptor(),
    ]);
  }
}
