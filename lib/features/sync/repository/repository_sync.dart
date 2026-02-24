import 'package:pump_progress_frontend/features/category/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/equipment/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/exercise/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/muscle/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/sets/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/sync/api/api.dart';
import 'package:pump_progress_frontend/features/sync/local/local_sync.dart';
import 'package:pump_progress_frontend/features/workout/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class RepositorySync {
  final LocalSync localSync = LocalSync();
  final ApiSyncPp apiSync = ApiSyncPp();

  RepositorySync();

  Future<void> _syncGet<T extends DBRow>({required String tableName}) async {
    final lastSync = await localSync.getLastSync(tableName);
    final remoteChanges = await apiSync.getRowsSync<T>(
      tableName: tableName,
      time: lastSync,
    );
    AppLogger.debug(
        'Remote changes for $tableName: ${remoteChanges.data.length}');
    await localSync.insertGeneric<T>(remoteChanges.data);
  }

  Future<void> _syncPost<T extends DbRowWrite>(
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
  }

  Future<void> syncTables() async {
    await _syncGet<CategoryRow>(tableName: CategoryRow.tableNameStatic);
    await _syncGet<MuscleRow>(tableName: MuscleRow.tableNameStatic);
    await _syncGet<EquipmentRow>(tableName: EquipmentRow.tableNameStatic);
    await _syncGet<ExerciseRow>(tableName: ExerciseRow.tableNameStatic);

    await _syncPost<WorkoutRow>(tableName: WorkoutRow.tableNameStatic);
    await _syncPost<WorkoutExercisesRow>(
        tableName: WorkoutExercisesRow.tableNameStatic);
    await _syncPost<SetsRow>(tableName: SetsRow.tableNameStatic);
  }
}
