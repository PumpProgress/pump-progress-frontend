import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/data/sqlite/index.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';
import 'package:pump_progress_frontend/repositories/models/rows/post/sets_row.dart';
import 'package:pump_progress_frontend/repositories/models/rows/post/workout_exercises.dart';
import 'package:pump_progress_frontend/repositories/models/rows/post/workout_row.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc({required this.pumpProgressRepository}) : super(SyncState()) {
    on<StartSyncEvent>(_onStartSyncEvent);
  }
  final PumpProgressRepository pumpProgressRepository;

  Future<void> _onStartSyncEvent(
      StartSyncEvent event, Emitter<SyncState> emit) async {
    emit(SyncState(status: SyncStatus.inProgress));
    final path = await DatabaseHelper.instance.getDatabasePath;
    print('Database path: $path');

    // final postTablesToSync = [
    //   PostSyncTable<WorkoutRow>(
    //     tableName: WorkoutRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(WorkoutRow.tableNameStatic),
    //     getDirtyRows: () => DatabaseHelper.instance
    //         .getDirtyRows<WorkoutRow>(WorkoutRow.tableNameStatic),
    //     postSync: (rows, lastSync) =>
    //         pumpProgressRepository.postRowsSync<WorkoutRow>(
    //       tableName: WorkoutRow.tableNameStatic,
    //       updates: rows,
    //       time: lastSync,
    //     ),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<WorkoutRow>(rows),
    //     markClean: (rows) => DatabaseHelper.instance
    //         .markClean<WorkoutRow>(WorkoutRow.tableNameStatic, rows),
    //     readTable: () => DatabaseHelper.instance
    //         .readTable<WorkoutRow>(WorkoutRow.tableNameStatic),
    //   ),
    //   PostSyncTable<WorkoutExercisesRow>(
    //     tableName: WorkoutExercisesRow.tableNameStatic,
    //     getLastSync: () => DatabaseHelper.instance
    //         .getLastSync(WorkoutExercisesRow.tableNameStatic),
    //     getDirtyRows: () => DatabaseHelper.instance
    //         .getDirtyRows<WorkoutExercisesRow>(
    //             WorkoutExercisesRow.tableNameStatic),
    //     postSync: (rows, lastSync) =>
    //         pumpProgressRepository.postRowsSync<WorkoutExercisesRow>(
    //       tableName: WorkoutExercisesRow.tableNameStatic,
    //       updates: rows,
    //       time: lastSync,
    //     ),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<WorkoutExercisesRow>(rows),
    //     markClean: (rows) => DatabaseHelper.instance
    //         .markClean<WorkoutExercisesRow>(
    //             WorkoutExercisesRow.tableNameStatic, rows),
    //     readTable: () => DatabaseHelper.instance.readTable<WorkoutExercisesRow>(
    //         WorkoutExercisesRow.tableNameStatic),
    //   ),
    //   PostSyncTable<SetsRow>(
    //     tableName: SetsRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(SetsRow.tableNameStatic),
    //     getDirtyRows: () => DatabaseHelper.instance
    //         .getDirtyRows<SetsRow>(SetsRow.tableNameStatic),
    //     postSync: (rows, lastSync) =>
    //         pumpProgressRepository.postRowsSync<SetsRow>(
    //       tableName: SetsRow.tableNameStatic,
    //       updates: rows,
    //       time: lastSync,
    //     ),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<SetsRow>(rows),
    //     markClean: (rows) => DatabaseHelper.instance
    //         .markClean<SetsRow>(SetsRow.tableNameStatic, rows),
    //     readTable: () =>
    //         DatabaseHelper.instance.readTable<SetsRow>(SetsRow.tableNameStatic),
    //   ),
    // ];

    // final getTablesToSync = [
    //   GetSyncTable<CategoryRow>(
    //     tableName: CategoryRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(CategoryRow.tableNameStatic),
    //     readTable: () => DatabaseHelper.instance
    //         .readTable<CategoryRow>(CategoryRow.tableNameStatic),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<CategoryRow>(rows),
    //     getSync: (lastSync) => pumpProgressRepository.getRowsSync<CategoryRow>(
    //       tableName: CategoryRow.tableNameStatic,
    //       time: lastSync,
    //     ),
    //   ),
    //   GetSyncTable<MuscleRow>(
    //     tableName: MuscleRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(MuscleRow.tableNameStatic),
    //     readTable: () => DatabaseHelper.instance
    //         .readTable<MuscleRow>(MuscleRow.tableNameStatic),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<MuscleRow>(rows),
    //     getSync: (lastSync) => pumpProgressRepository.getRowsSync<MuscleRow>(
    //       tableName: MuscleRow.tableNameStatic,
    //       time: lastSync,
    //     ),
    //   ),
    //   GetSyncTable<EquipmentRow>(
    //     tableName: EquipmentRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(EquipmentRow.tableNameStatic),
    //     readTable: () => DatabaseHelper.instance
    //         .readTable<EquipmentRow>(EquipmentRow.tableNameStatic),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<EquipmentRow>(rows),
    //     getSync: (lastSync) => pumpProgressRepository.getRowsSync<EquipmentRow>(
    //       tableName: EquipmentRow.tableNameStatic,
    //       time: lastSync,
    //     ),
    //   ),
    //   GetSyncTable<ExerciseRow>(
    //     tableName: ExerciseRow.tableNameStatic,
    //     getLastSync: () =>
    //         DatabaseHelper.instance.getLastSync(ExerciseRow.tableNameStatic),
    //     readTable: () => DatabaseHelper.instance
    //         .readTable<ExerciseRow>(ExerciseRow.tableNameStatic),
    //     insertRows: (rows) =>
    //         DatabaseHelper.instance.insertGeneric<ExerciseRow>(rows),
    //     getSync: (lastSync) => pumpProgressRepository.getRowsSync<ExerciseRow>(
    //       tableName: ExerciseRow.tableNameStatic,
    //       time: lastSync,
    //     ),
    //   ),
    // ];

    // for (final table in getTablesToSync) {
    //   print('Fetching table: ${table.tableName}');
    //   final lastSync = await table.getLastSync();
    //   print('Last sync for table ${table.tableName}: $lastSync');

    //   final remoteChanges = await table.getSync(lastSync);
    //   print(
    //       'Remote changes for table ${table.tableName}: ${remoteChanges.length} rows');

    //   await table.insertRows(remoteChanges);
    //   print('✅ Finished fetching table: ${table.tableName}');

    //   final data = await table.readTable(); // Optional: read back the table
    //   print('Data in table ${table.tableName} with ${data.length} rows: $data');
    // }

    // for (final table in postTablesToSync) {
    //   print('🔄 Syncing table: ${table.tableName}');

    //   final lastSync = await table.getLastSync();
    //   print('Last sync for table ${table.tableName}: $lastSync');
    //   final localChanges = await table.getDirtyRows();
    //   print(
    //       'Local changes for table ${table.tableName}: ${localChanges.length} rows');

    //   final remoteChanges = await table.postSync(localChanges, lastSync);
    //   print(
    //       'Remote changes for table ${table.tableName}: ${remoteChanges.length} rows');

    //   await table.insertRows(remoteChanges);
    //   print('Inserted remote changes into table ${table.tableName}');

    //   await table.markClean(localChanges);

    //   final data = await table.readTable(); // Optional: read back the table
    //   print('Data in table ${table.tableName} with ${data.length} rows: $data');

    //   print('✅ Finished syncing table: ${table.tableName}');
    // }

    emit(SyncState(status: SyncStatus.inProgress));

    final db = DatabaseHelper.instance;
    final repo = pumpProgressRepository;

    // 1️⃣ SYNC GET — FROM SERVER TO LOCAL

    // ---- Category ----
    {
      final lastSync = await db.getLastSync(CategoryRow.tableNameStatic);
      final remoteChanges = await repo.getRowsSync<CategoryRow>(
        tableName: CategoryRow.tableNameStatic,
        time: lastSync,
      );
      await db.insertGeneric<CategoryRow>(remoteChanges);
    }

    // ---- Muscle ----
    {
      final lastSync = await db.getLastSync(MuscleRow.tableNameStatic);
      final remoteChanges = await repo.getRowsSync<MuscleRow>(
        tableName: MuscleRow.tableNameStatic,
        time: lastSync,
      );
      await db.insertGeneric<MuscleRow>(remoteChanges);
    }

    // ---- Equipment ----
    {
      final lastSync = await db.getLastSync(EquipmentRow.tableNameStatic);
      final remoteChanges = await repo.getRowsSync<EquipmentRow>(
        tableName: EquipmentRow.tableNameStatic,
        time: lastSync,
      );
      await db.insertGeneric<EquipmentRow>(remoteChanges);
    }

    // ---- Exercise ----
    {
      final lastSync = await db.getLastSync(ExerciseRow.tableNameStatic);
      final remoteChanges = await repo.getRowsSync<ExerciseRow>(
        tableName: ExerciseRow.tableNameStatic,
        time: lastSync,
      );
      await db.insertGeneric<ExerciseRow>(remoteChanges);
    }

    // 2️⃣ SYNC POST — FROM LOCAL TO SERVER

    // ---- Workout ----
    {
      final lastSync = await db.getLastSync(WorkoutRow.tableNameStatic);
      final localChanges =
          await db.getDirtyRows<WorkoutRow>(WorkoutRow.tableNameStatic);
      final remoteChanges = await repo.postRowsSync<WorkoutRow>(
        tableName: WorkoutRow.tableNameStatic,
        updates: localChanges,
        time: lastSync,
      );
      await db.insertGeneric<WorkoutRow>(remoteChanges);
      await db.markClean<WorkoutRow>(WorkoutRow.tableNameStatic, localChanges);
    }

    // ---- WorkoutExercises ----
    {
      final lastSync =
          await db.getLastSync(WorkoutExercisesRow.tableNameStatic);
      final localChanges = await db.getDirtyRows<WorkoutExercisesRow>(
          WorkoutExercisesRow.tableNameStatic);
      final remoteChanges = await repo.postRowsSync<WorkoutExercisesRow>(
        tableName: WorkoutExercisesRow.tableNameStatic,
        updates: localChanges,
        time: lastSync,
      );
      await db.insertGeneric<WorkoutExercisesRow>(remoteChanges);
      await db.markClean<WorkoutExercisesRow>(
          WorkoutExercisesRow.tableNameStatic, localChanges);
    }

    // ---- Sets ----
    {
      final lastSync = await db.getLastSync(SetsRow.tableNameStatic);
      final localChanges =
          await db.getDirtyRows<SetsRow>(SetsRow.tableNameStatic);
      final remoteChanges = await repo.postRowsSync<SetsRow>(
        tableName: SetsRow.tableNameStatic,
        updates: localChanges,
        time: lastSync,
      );
      await db.insertGeneric<SetsRow>(remoteChanges);
      await db.markClean<SetsRow>(SetsRow.tableNameStatic, localChanges);
    }

    emit(SyncState(status: SyncStatus.success));
  }
}
