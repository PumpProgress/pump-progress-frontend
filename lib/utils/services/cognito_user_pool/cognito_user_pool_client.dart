part of 'cognito_user_pool.dart';

class _ErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    print(error);
    final hint = Hint();
    Sentry.captureException(error, stackTrace: error.stackTrace, hint: hint);
    super.onError(error, handler);
  }
}

class PPUserPool {
  late Dio client;
  static final PPUserPool _singleton = PPUserPool._internal();
  factory PPUserPool() {
    return _singleton;
  }

  PPUserPool._internal() {
    final options = BaseOptions(
      baseUrl: "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/",
    );
    client = Dio(options);
    client.interceptors.addAll([
      _ErrorLogInterceptor(),
    ]);
  }

  Future<CognitoUserSession> getTokenDataFromCode(authCode) async {
    final Map<String, String> body = {
      'grant_type': 'authorization_code',
      'client_id': COGNITO_CLIENT_ID,
      'client_secret': CLIENT_SECRET,
      'code': authCode,
      'redirect_uri': REDIRECT_URI,
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final res = await client.post(
      "token/",
      data: body,
      options: Options(headers: headers),
    );
    if (res.statusCode != 200) {
      throw Exception(
          "Received bad status code from Cognito for auth code: ${res.statusCode}; \n body: ${res.data}");
    }

    final idToken = CognitoIdToken(res.data['id_token']);
    final accessToken = CognitoAccessToken(res.data['access_token']);
    final refreshToken = CognitoRefreshToken(res.data['refresh_token']);
    return CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
  }

  Future<CognitoUserSession> renewCognitoTokens(
      String initialRefreshToken) async {
    final body = {
      'grant_type': 'refresh_token',
      'client_id': COGNITO_CLIENT_ID,
      'refresh_token': initialRefreshToken,
      'client_secret': CLIENT_SECRET,
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final res = await client.post(
      "token/",
      data: body,
      options: Options(headers: headers),
    );

    if (res.statusCode != 200) {
      throw Exception(
          "Received bad status code from Cognito for refresh token: ${res.statusCode}; \n body: ${res.data}");
    }

    final idToken = CognitoIdToken(res.data['id_token']);
    final accessToken = CognitoAccessToken(res.data['access_token']);
    final refreshToken = CognitoRefreshToken(res.data['refresh_token']);
    return CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
  }

// TODO refactor this long string
  String getLoginUrl(String provider) {
    return "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/authorize?identity_provider=$provider&redirect_uri=$REDIRECT_URI&response_type=CODE&client_id=$COGNITO_CLIENT_ID&scope=${SCOPES.join("+")}";
  }
}
