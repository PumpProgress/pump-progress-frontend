import 'package:pump_progress_frontend/features/exercise/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';

class LocalExercise {
  final db = SqlDatabaseService.instance.database;

  Future<List<ExerciseRow>> getExercises({List<int>? exerciseIds}) async {
    final database = await db;
    final exercisesResult = exerciseIds == null
        ? await database.rawQuery('''SELECT * FROM exercises 
            WHERE deleted_at IS NULL 
            ''')
        : await database.rawQuery('''SELECT * FROM exercises 
            WHERE id IN (${exerciseIds.map((id) => id.toString()).join(',')})
            AND deleted_at IS NULL 
            ''');
    return exercisesResult
        .map((exercise) => ExerciseRow.fromDB(exercise))
        .toList();
  }

  Future<ExerciseRow> getExerciseById(int exerciseId) async {
    final database = await db;
    final exerciseResult = await database.rawQuery('''SELECT * FROM exercises 
        WHERE id = $exerciseId
        AND deleted_at IS NULL 
        ''');
    return ExerciseRow.fromDB(exerciseResult.first);
  }

  Future<List<ExerciseRow>> searchExercises(
      {required String searchTerm}) async {
    final database = await db;
    final exercisesResult = await database.rawQuery('''SELECT * FROM exercises
        WHERE name LIKE '%$searchTerm%'
        AND deleted_at IS NULL
        ''');
    return exercisesResult
        .map((exercise) => ExerciseRow.fromDB(exercise))
        .toList();
  }

  Future<List<ExerciseRow>> getExercisesByMuscle({
    required String muscleName,
    int limit = 10,
  }) async {
    final database = await db;
    final exercisesResult = await database.rawQuery('''SELECT e.* FROM exercises e
        JOIN muscles m ON e.primary_muscle_id = m.id
        WHERE LOWER(m.name) LIKE LOWER(?)
        AND e.deleted_at IS NULL
        LIMIT ?
        ''', ['%$muscleName%', limit]);
    return exercisesResult.map((row) => ExerciseRow.fromDB(row)).toList();
  }

  /// Loads every exercise with FK names resolved (category, equipment, primary
  /// muscle) and its full muscle list (primary + secondary).
  Future<List<Map<String, dynamic>>> getAllExercisesEnriched() async {
    final database = await db;

    final rows = await database.rawQuery('''
      SELECT
        e.id            AS id,
        e.code          AS code,
        e.name          AS name,
        e.force         AS force,
        e.level         AS level,
        e.mechanic      AS mechanic,
        c.name          AS category,
        eq.name         AS equipment,
        pm.name         AS primary_muscle
      FROM exercises e
      LEFT JOIN category_types c ON e.category_id = c.id
      LEFT JOIN equipment_types eq ON e.equipment_id = eq.id
      LEFT JOIN muscles pm ON e.primary_muscle_id = pm.id
      WHERE e.deleted_at IS NULL
    ''');

    // Secondary muscle names grouped by exercise id.
    final secondaryRows = await database.rawQuery('''
      SELECT esm.exercise_id AS exercise_id, m.name AS muscle_name
      FROM exercise_secondary_muscles esm
      JOIN muscles m ON esm.muscle_id = m.id
      WHERE esm.deleted_at IS NULL
    ''');

    final secondaryByExercise = <int, List<String>>{};
    for (final row in secondaryRows) {
      final exerciseId = row['exercise_id'] as int;
      final muscleName = row['muscle_name'] as String?;
      if (muscleName == null) continue;
      secondaryByExercise.putIfAbsent(exerciseId, () => []).add(muscleName);
    }

    return rows.map((row) {
      final id = row['id'] as int;
      final muscles = <String>[
        if (row['primary_muscle'] != null) row['primary_muscle'] as String,
        ...?secondaryByExercise[id],
      ];
      return <String, dynamic>{
        'id': id,
        'code': row['code'],
        'name': row['name'],
        'category': row['category'] ?? '',
        'muscles': muscles,
        'equipment': row['equipment'],
        'force': row['force'],
        'mechanic': row['mechanic'],
        'level': row['level'],
      };
    }).toList();
  }
}
