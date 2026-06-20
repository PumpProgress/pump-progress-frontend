import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDatabaseService {
  static final SqlDatabaseService instance = SqlDatabaseService._init();

  static Database? _database;

  SqlDatabaseService._init();

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
    // review join method and try to change with another one cause weird import from path package
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
      intensity INTEGER,
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

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
