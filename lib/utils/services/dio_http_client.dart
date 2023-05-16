import 'dart:html';

import 'package:dio/dio.dart';

class PumpProgressApiDio {
  factory PumpProgressApiDio() {
    return _singleton;
  }
  PumpProgressApiDio._internal() {
    dio = Dio(options);
    dio.interceptors.addAll([
      // authTokenInterceptor, errorHandlerInterceptor,
    ]);
  }
  static final PumpProgressApiDio _singleton = PumpProgressApiDio._internal();
  late Dio dio;
  static const urlProd =
      'https://23xlv17ugb.execute-api.us-east-1.amazonaws.com/api';
  static const urlDev = 'http://localhost:3000';
  static const baseUrl = urlProd;

  static final options = BaseOptions(
    baseUrl: baseUrl,
  );
}
