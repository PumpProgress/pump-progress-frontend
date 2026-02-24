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
}
