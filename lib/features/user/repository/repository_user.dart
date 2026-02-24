import 'package:pump_progress_frontend/features/user/api/api.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

class RepositoryUser {
  final ApiUser apiUser = ApiUser();

  Future<User> getUser(String userId) async {
    final user = await apiUser.getUser(userId);
    return User.fromJson(user.toJson());
  }
}
