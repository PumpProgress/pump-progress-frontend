part of 'cognito_user_pool.dart';

class _ErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    Sentry.captureException(error, stackTrace: error.stackTrace);
    super.onError(error, handler);
  }
}

class UsersPoolService {
  late Dio client;
  static final UsersPoolService _singleton = UsersPoolService._internal();
  factory UsersPoolService() {
    return _singleton;
  }

  UsersPoolService._internal() {
    final options = BaseOptions(
      baseUrl: "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/",
    );
    client = Dio(options);
    client.interceptors.addAll([
      SentryDioInterceptor(),
      _ErrorLogInterceptor(),
    ]);
  }

  static const COGNITO_POOL_URL = 'pump-progress.auth.us-east-1';
  static const COGNITO_CLIENT_ID = '3pb5p2itq4hn3310n248uisj1';
  static const CLIENT_SECRET =
      'q1qv2u4pd4ivq2hljpdk40pf4bbjv6h04etk7el1hthvjks3il0';
  static const USER_POOL_ID = 'us-east-1_nCqvFmutS';
  static const REDIRECT_URI = "myapp://pumpprogress";
  static const SCOPES = ["email", "openid", "profile"];
  static const GOOGLE_CLIENT_ID =
      "922895573491-fvcnk3si3pjf358lqlrdd3av3r4nss60.apps.googleusercontent.com";

// TODO refactor this long string
  String getLoginUrl(String provider) {
    return "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/authorize?identity_provider=$provider&redirect_uri=$REDIRECT_URI&response_type=CODE&client_id=$COGNITO_CLIENT_ID&scope=${SCOPES.join("+")}";
  }
}
