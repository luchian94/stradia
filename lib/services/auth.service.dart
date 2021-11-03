import 'package:ai_way/constants/constants.dart';
import 'package:dio/dio.dart';

class AuthenticationService {
  late Dio dio;

  late String authenticationToken;

  AuthenticationService() {
    dio = Dio();
    dio.options.contentType= Headers.formUrlEncodedContentType;
  }

  Future<void> getAuthenticationToken() async {
    var response = await dio.post(
      Constants.authenticationUrl,
      data: {
        'grant_type': 'client_credentials',
        'scope': Constants.authenticationScope,
        'client_id': Constants.clientId,
        'client_secret': Constants.clientSecret,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    authenticationToken = response.data['access_token'];
  }
}
