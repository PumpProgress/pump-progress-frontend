import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';
import 'package:sqflite/sqflite.dart';

class LocalSync {
  final SqlDatabaseService sqlDatabaseService = SqlDatabaseService.instance;

  LocalSync();

  Future<void> insertGeneric<T extends DBRow>(List<T> items) async {
    final db = await sqlDatabaseService.database;
    final batch = db.batch();

    for (var item in items) {
      batch.insert(
        item.tableName,
        item.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<DateTime> getLastSync(String table) async {
    // query the latest updated_at from the table table and is_dirty = 0
    final db = await sqlDatabaseService.database;
    final hasIsDirty = await hasColumn(db, table, 'is_dirty');

    final where = hasIsDirty ? 'is_dirty = 0' : null;

    final result = await db.query(
      table,
      columns: ['updated_at'],
      orderBy: 'updated_at DESC',
      where: where,
      limit: 1,
    );

    if (result.isNotEmpty && result.first['updated_at'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
          result.first['updated_at'] as int);
    }

    // Default: 1970 (never synced)
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<bool> hasColumn(Database db, String table, String column) async {
    final result = await db.rawQuery('PRAGMA table_info($table);');
    return result.any((row) => row['name'] == column);
  }

  Future<List<T>> getDirtyRows<T extends DBRow>(String table) async {
    final db = await sqlDatabaseService.database;
    final results = await db.query(table, where: 'is_dirty = 1');
    return results.map((e) => DBRowFactory.fromDB<T>(e)).toList();
  }

  Future<void> markClean<T extends DbRowWrite>(
      String table, List<T> rows) async {
    final db = await sqlDatabaseService.database;
    final batch = db.batch();
    for (final row in rows) {
      batch.update(table, {'is_dirty': 0},
          where: 'id = ?', whereArgs: [row.id]);
    }
    await batch.commit(noResult: true);
  }

  Future<List<T>> readTable<T extends DBRow>(String table) async {
    final db = await sqlDatabaseService.database;
    final results = await db.query(table);
    return results.map((e) => DBRowFactory.fromDB<T>(e)).toList();
  }
}
