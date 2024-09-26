import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/config/constants/flavor.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
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
  late Dio dio;

  static final options = BaseOptions(
    baseUrl: FlavorConfig.baseUrl,
  );
}

final authTokenInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (options.method.toUpperCase() == 'OPTIONS') {
        handler.next(options);
        return;
      }
      final jwt = prefs.getString(jwtKey);
      if (jwt == null || jwt.isEmpty) {
        handler.next(options);
        return;
      }
      options.headers
          .addEntries([MapEntry<String, String>('Authorization', jwt)]);
    } catch (e) {
      log('no auth token');
    }
    return handler.next(options);
  },
);
