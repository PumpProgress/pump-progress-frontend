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
  static const baseUrl =
      'https://23xlv17ugb.execute-api.us-east-1.amazonaws.com/api';
  static final options = BaseOptions(
    baseUrl: baseUrl,
  );
}
