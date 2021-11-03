import 'package:ai_way/services/auth.service.dart';
import 'package:dio/dio.dart';

import '../../locator.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = _authenticationService.authenticationToken;
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }
}
