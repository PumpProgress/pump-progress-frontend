import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';

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
  static const urlProd =
      'https://23xlv17ugb.execute-api.us-east-1.amazonaws.com/api';
  static const urlDev = 'http://localhost:3000';
  static const baseUrl = urlProd;

  static final options = BaseOptions(
    baseUrl: urlProd,
  );
}

final storageUtil = HiveStorage();

final authTokenInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    try {
      if (options.method.toUpperCase() == 'OPTIONS') {
        handler.next(options);
        return;
      }
      final jwt = HiveStorage.authBox!.get(LocalStorageKey.jwt);
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
