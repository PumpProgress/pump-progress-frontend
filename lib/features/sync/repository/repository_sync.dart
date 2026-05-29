import 'package:pump_progress_frontend/features/category/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/equipment/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/exercise/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/muscle/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/sets/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/sync/api/api.dart';
import 'package:pump_progress_frontend/features/sync/local/local_sync.dart';
import 'package:pump_progress_frontend/features/sync/models/sync_result.dart';
import 'package:pump_progress_frontend/features/workout/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class RepositorySync {
  final LocalSync localSync = LocalSync();
  final ApiSyncPp apiSync = ApiSyncPp();

  RepositorySync();

  Future<int> _syncGet<T extends DBRow>({required String tableName}) async {
    final lastSync = await localSync.getLastSync(tableName);
    final remoteChanges = await apiSync.getRowsSync<T>(
      tableName: tableName,
      time: lastSync,
    );
    AppLogger.debug(
        'Remote changes for $tableName: ${remoteChanges.data.length}');
    await localSync.insertGeneric<T>(remoteChanges.data);
    return remoteChanges.data.length;
  }

  Future<SyncPostResult> _syncPost<T extends DbRowWrite>(
      {required String tableName}) async {
    final lastSync = await localSync.getLastSync(tableName);
    final localChanges = await localSync.getDirtyRows<T>(tableName);

    AppLogger.debug('Local changes for $tableName: ${localChanges.length}');
    final remoteChanges = await apiSync.postRowsSync<T>(
      tableName: tableName,
      updates: localChanges,
      time: lastSync,
    );
    await localSync.insertGeneric<T>(remoteChanges.updates);
    AppLogger.debug(
        'Remote changes for $tableName: ${remoteChanges.updates.length}');
    await localSync.markClean<T>(tableName, localChanges);
    return SyncPostResult(
      sent: localChanges.length,
      received: remoteChanges.updates.length,
    );
  }

  Future<SyncResult> syncTables() async {
    var totalReceived = 0;
    var totalSent = 0;

    totalReceived +=
        await _syncGet<CategoryRow>(tableName: CategoryRow.tableNameStatic);
    totalReceived +=
        await _syncGet<MuscleRow>(tableName: MuscleRow.tableNameStatic);
    totalReceived +=
        await _syncGet<EquipmentRow>(tableName: EquipmentRow.tableNameStatic);
    totalReceived +=
        await _syncGet<ExerciseRow>(tableName: ExerciseRow.tableNameStatic);

    final workoutPost =
        await _syncPost<WorkoutRow>(tableName: WorkoutRow.tableNameStatic);
    totalReceived += workoutPost.received;
    totalSent += workoutPost.sent;

    final workoutExercisesPost = await _syncPost<WorkoutExercisesRow>(
        tableName: WorkoutExercisesRow.tableNameStatic);
    totalReceived += workoutExercisesPost.received;
    totalSent += workoutExercisesPost.sent;

    final setsPost =
        await _syncPost<SetsRow>(tableName: SetsRow.tableNameStatic);
    totalReceived += setsPost.received;
    totalSent += setsPost.sent;

    return SyncResult(totalReceived: totalReceived, totalSent: totalSent);
  }
}
