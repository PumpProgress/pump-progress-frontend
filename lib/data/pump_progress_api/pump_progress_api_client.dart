import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/config/constants/flavor.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/utils/services/congito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PumpProgressApiDio {
  factory PumpProgressApiDio() {
    return _singleton;
  }
  PumpProgressApiDio._internal() {
    dio = Dio(options);
    dio.interceptors.addAll([
      authTokenInterceptor,
      //  errorHandlerInterceptor,
    ]);
  }

  static final PumpProgressApiDio _singleton = PumpProgressApiDio._internal();
  static late Dio dio;

  static final options = BaseOptions(
    baseUrl: FlavorConfig.baseUrl,
  );

  static final authTokenInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) async {
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
          MapEntry<String, String>('X-ID-Token', '$tokenId')
        ]);
      } catch (e) {
        print('no auth token');
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        if (error.requestOptions.headers.containsKey('X-Avoid-Retry')) {
          handler.next(error);
          return;
        }
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final refreshToken = prefs.getString(refreshTokenKey);
          if (refreshToken == null) {
            handler.next(error);
            return;
          }
          error.requestOptions.headers['X-Avoid-Retry'] = 'true';

          final session = await renewCognitoTokens(refreshToken);

          final newAccessToken = session.accessToken.jwtToken;
          final newIdToken = session.idToken.jwtToken;

          prefs.setString(accessTokenKey, newAccessToken!);
          prefs.setString(idTokenKey, newIdToken!);

          error.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          error.requestOptions.headers['X-ID-Token'] = newIdToken;

          final response = await PumpProgressApiDio.dio.request(
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
        } catch (e) {
          handler.next(error);
          return;
        }
      }
      handler.next(error);
    },
  );
}
