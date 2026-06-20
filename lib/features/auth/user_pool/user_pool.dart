import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/utils/services/services.dart';

class PoolUsers {
  final UsersPoolService service = UsersPoolService();

  Future<CognitoUserSession> getTokenDataFromCode(String authCode) async {
    final Map<String, String> body = {
      'grant_type': 'authorization_code',
      'client_id': UsersPoolService.COGNITO_CLIENT_ID,
      'client_secret': UsersPoolService.CLIENT_SECRET,
      'code': authCode,
      'redirect_uri': UsersPoolService.REDIRECT_URI,
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final res = await service.client.post(
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
      'client_id': UsersPoolService.COGNITO_CLIENT_ID,
      'refresh_token': initialRefreshToken,
      'client_secret': UsersPoolService.CLIENT_SECRET,
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final res = await service.client.post(
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

  String getLoginUrl(String provider) {
    return service.getLoginUrl(provider);
  }
}
