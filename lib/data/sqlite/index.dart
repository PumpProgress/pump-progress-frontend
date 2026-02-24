import 'dart:async';
import 'package:path/path.dart';
import 'package:pump_progress_frontend/data/sqlite/db_row.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Expose database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pump_progress.db');
    return _database!;
  }

  Future<String> get getDatabasePath async {
    final db = await instance.database;
    return db.path;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON;');

    // Read tables
    await db.execute('''
      CREATE TABLE IF NOT EXISTS muscles (
          id INTEGER PRIMARY KEY,
          name TEXT UNIQUE NOT NULL,
          code TEXT UNIQUE NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER
      );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS equipment_types (
          id INTEGER PRIMARY KEY,
          name TEXT UNIQUE NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER
      );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS category_types (
          id INTEGER PRIMARY KEY,
          name TEXT UNIQUE NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER
      );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises (
          id INTEGER PRIMARY KEY,
          code TEXT UNIQUE NOT NULL,
          name TEXT NOT NULL,
          primary_muscle_id INTEGER,
          force TEXT,
          level TEXT,
          mechanic TEXT,
          equipment_id INTEGER,
          category_id INTEGER,
          instructions TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER,
          FOREIGN KEY (primary_muscle_id) REFERENCES muscles(id),
          FOREIGN KEY (equipment_id) REFERENCES equipment_types(id),
          FOREIGN KEY (category_id) REFERENCES category_types(id)
      );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_secondary_muscles (
          exercise_id INTEGER,
          muscle_id INTEGER,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER,
          PRIMARY KEY (exercise_id, muscle_id),
          FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE,
          FOREIGN KEY (muscle_id) REFERENCES muscles(id) ON DELETE CASCADE
      );''');

    // Read/write tables
    // workouts
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workouts (
          id TEXT PRIMARY KEY,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER,
          user_id TEXT NOT NULL,
          name TEXT NOT NULL,
          is_dirty INTEGER NOT NULL DEFAULT 0
      );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_exercises (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          workout_id TEXT NOT NULL,
          exercise_id INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted_at INTEGER,
          is_dirty INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (workout_id) REFERENCES workouts(id),
          FOREIGN KEY (exercise_id) REFERENCES exercises(id)
        );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sets (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      exercise_id INTEGER NOT NULL,
      repetitions INTEGER NOT NULL,
      weight REAL NOT NULL,
      intensity REAL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      deleted_at INTEGER,
      is_dirty INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (exercise_id) REFERENCES exercises(id)
    );''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_state (
      table_name TEXT PRIMARY KEY,
      last_sync TEXT
    ); ''');
  }

  Future<void> insertGeneric<T extends DBRow>(List<T> items) async {
    final db = await instance.database;
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
    final db = await instance.database;
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
    final db = await instance.database;
    final results = await db.query(table, where: 'is_dirty = 1');
    return results.map((e) => DBRowFactory.fromMap<T>(e)).toList();
  }

  Future<void> markClean<T extends DbRowWrite>(
      String table, List<T> rows) async {
    final db = await instance.database;
    final batch = db.batch();
    for (final row in rows) {
      batch.update(table, {'is_dirty': 0},
          where: 'id = ?', whereArgs: [row.id]);
    }
    await batch.commit(noResult: true);
  }

  Future<List<T>> readTable<T extends DBRow>(String table) async {
    final db = await instance.database;
    final results = await db.query(table);
    return results.map((e) => DBRowFactory.fromDB<T>(e)).toList();
  }

  // Example query
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final db = await instance.database;
    return await db.query('category_types');
  }

  // Close DB
  Future close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
