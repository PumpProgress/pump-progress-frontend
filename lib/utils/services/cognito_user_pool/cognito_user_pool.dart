import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

part 'cognito_user_pool_client.dart';

// TODO refactor with Dio for example

const COGNITO_POOL_URL = 'pump-progress.auth.us-east-1';
const COGNITO_CLIENT_ID = '3pb5p2itq4hn3310n248uisj1';
const CLIENT_SECRET = 'q1qv2u4pd4ivq2hljpdk40pf4bbjv6h04etk7el1hthvjks3il0';
const USER_POOL_ID = 'us-east-1_nCqvFmutS';
const REDIRECT_URI = "myapp://pumpprogress";
const SCOPES = ["email", "openid", "profile"];

@Deprecated("Not being used, doesnt work as expected")
final userPool = CognitoUserPool(
  USER_POOL_ID,
  COGNITO_CLIENT_ID,
  clientSecret: CLIENT_SECRET,
);

@Deprecated("Use CognitoDio")
Future<CognitoUserSession> getTokenDataFromCode(authCode) async {
  String url = "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/token";

  // Data for the POST request
  final Map<String, String> body = {
    'grant_type': 'authorization_code',
    'client_id': COGNITO_CLIENT_ID,
    'client_secret': CLIENT_SECRET,
    'code': authCode,
    'redirect_uri': 'myapp://pumpprogress',
  };

  // Headers (optional, adjust as needed)
  final headers = {
    'Content-Type':
        'application/x-www-form-urlencoded', // Content-Type for form data
  };

  final uri = Uri.parse(url);
  final response = await http.post(uri, body: body, headers: headers);
  if (response.statusCode != 200) {
    throw Exception(
        "Received bad status code from Cognito for auth code: ${response.statusCode}; body: ${response.body}");
  }

  final tokenData = json.decode(response.body);
  final idToken = CognitoIdToken(tokenData['id_token']);
  final accessToken = CognitoAccessToken(tokenData['access_token']);
  final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
  return CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
}

@Deprecated("Use CognitoDio")
Future<CognitoUserSession> renewCognitoTokens(
    String initialRefreshToken) async {
  final url =
      Uri.parse('https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/token');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'refresh_token',
      'client_id': COGNITO_CLIENT_ID,
      'refresh_token': initialRefreshToken,
      'client_secret': CLIENT_SECRET,
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
        "Received bad status code from Cognito for refresh token: ${response.statusCode}; body: ${response.body}");
  }

  final tokenData = json.decode(response.body);
  final idToken = CognitoIdToken(tokenData['id_token']);
  final accessToken = CognitoAccessToken(tokenData['access_token']);
  final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
  return CognitoUserSession(idToken, accessToken, refreshToken: refreshToken);
}

@Deprecated("Use CognitoDio")
String getLoginUrl(String provider) {
  return "https://$COGNITO_POOL_URL.amazoncognito.com/oauth2/authorize?identity_provider=$provider&redirect_uri=myapp://pumpprogress&response_type=CODE&client_id=$COGNITO_CLIENT_ID&scope=email+openid+profile";
}
