import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'interceptors/token.interceptor.dart';

class DioClient {
  static Dio getInstance(String baseApiUrl) {
    Dio dio = new Dio();
    dio..options.baseUrl = baseApiUrl;
    dio.interceptors.add(TokenInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: false));
    }

    return dio;
  }
}
