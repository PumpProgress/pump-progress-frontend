import 'package:pump_progress_frontend/features/user/models/dto/dto.dart';
import 'package:pump_progress_frontend/utils/services/api_client_pp/api_client_pp.dart';

class ApiUser {
  final apiClientPp = PumpProgressApiDio().client;

  Future<UserAPI> getUser(String userId) async {
    final response = await apiClientPp.get(
      '/users/$userId',
    );
    return UserAPI.fromMap(response.data!);
  }
}
