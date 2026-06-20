import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:pump_progress_frontend/features/auth/user_pool/user_pool.dart';

class RepositoryAuth {
  final PoolUsers poolUsers = PoolUsers();

  String getLoginUrl(String provider) {
    return poolUsers.service.getLoginUrl(provider);
  }

  Future<CognitoUserSession> getTokenDataFromCode(String authCode) async {
    return await poolUsers.getTokenDataFromCode(authCode);
  }

  Future<CognitoUserSession> renewCognitoTokens(
      String initialRefreshToken) async {
    return await poolUsers.renewCognitoTokens(initialRefreshToken);
  }
}
