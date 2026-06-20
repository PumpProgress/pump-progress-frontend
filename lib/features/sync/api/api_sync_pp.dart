import 'package:pump_progress_frontend/features/sync/models/dto/dto.dart';
import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';
import 'package:pump_progress_frontend/utils/services/api_client_pp/api_client_pp.dart';

class ApiSyncPp {
  final apiClientPp = PumpProgressApiDio().client;

  ApiSyncPp();
  Future<GetSync<T>> getRowsSync<T extends DBRow>({
    required String tableName,
    DateTime? time,
  }) async {
    final response = await apiClientPp.get<String>(
      '/sync/$tableName',
      queryParameters: {
        'since': time?.toUtc().toIso8601String(),
      },
    );
    return GetSync<T>.fromJson(response.data!);
  }

  Future<PostSync<T>> postRowsSync<T extends DBRow>({
    required String tableName,
    required List<T> updates,
    required DateTime time,
  }) async {
    final response = await apiClientPp.post<String>(
      '/sync/$tableName',
      data: PostSync<T>(updates: updates, time: time).toJson(),
    );
    return PostSync<T>.fromJson(response.data!);
  }
}
