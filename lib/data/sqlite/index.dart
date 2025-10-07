import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pump_progress_frontend/repositories/models/index.dart';

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
    final db = await database;
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
  }

  Future<void> insertMuscles(List<MuscleRow> muscles) async {
    final db = await instance.database;

    final batch = db.batch();
    for (var muscle in muscles) {
      batch.insert(
        'muscles',
        muscle.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace, // upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertEquipment(List<EquipmentRow> equipment) async {
    final db = await instance.database;

    final batch = db.batch();
    for (var e in equipment) {
      batch.insert(
        'equipment_types',
        e.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace, // upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertCategories(List<CategoryRow> categories) async {
    final db = await instance.database;

    final batch = db.batch();
    for (var cat in categories) {
      batch.insert(
        'category_types',
        cat.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace, // upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertExercises(List<ExerciseRow> exercises) async {
    final db = await instance.database;

    final batch = db.batch();
    for (var ex in exercises) {
      batch.insert(
        'exercises',
        ex.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace, // upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertSecondaryMuscles(
      List<SecondaryMuscleRow> secondaryMuscles) async {
    final db = await instance.database;

    final batch = db.batch();
    for (var muscle in secondaryMuscles) {
      batch.insert(
        'exercise_secondary_muscles',
        muscle.toDB(),
        conflictAlgorithm: ConflictAlgorithm.replace, // upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int?> getLastCategoryChange() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT MAX(
      COALESCE(updated_at, 0),
      COALESCE(created_at, 0),
      COALESCE(deleted_at, 0)
    ) as latest
    FROM category_types
  ''');

    if (result.isNotEmpty && result.first['latest'] != null) {
      return result.first['latest'] as int; // epoch ms
    }
    return null;
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

// Future<void> createTables(Database db) async {
//   await db.execute('''
//     CREATE TABLE IF NOT EXISTS categories (
//       id INTEGER PRIMARY KEY,
//       name TEXT,
//       updated_at TEXT,
//       created_at TEXT,
//       deleted_at TEXT
//     )
//   ''');
// }
