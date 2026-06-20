import 'package:pump_progress_frontend/features/workout/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';
import 'package:uuid/uuid.dart';

class LocalWorkoutExercises {
  final db = SqlDatabaseService.instance.database;

  Future<List<WorkoutExercisesRow>> getWorkoutExercises(
      {required List<String> workoutIds}) async {
    final database = await db;
    final workoutExercisesResult = await database.query('workout_exercises',
        where: 'workout_id IN (${workoutIds.map((_) => '?').join(',')})',
        whereArgs: workoutIds);
    return workoutExercisesResult
        .map((row) => WorkoutExercisesRow.fromDB(row))
        .toList();
  }

  Future<List<WorkoutExercisesRow>> addExerciseToWorkout({
    required String workoutId,
    required int exerciseId,
    required String userId,
  }) async {
    final database = await db;
    final id = Uuid().v4();
    await database.insert('workout_exercises', {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'user_id': userId,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'is_dirty': 1,
    });
    final workoutExercisesResult = await database.query('workout_exercises',
        where: 'workout_id = ?', whereArgs: [workoutId]);
    return workoutExercisesResult
        .map((row) => WorkoutExercisesRow.fromDB(row))
        .toList();
  }

  Future<void> deleteAllExercisesFromWorkout({
    required String workoutId,
  }) async {
    final database = await db;
    await database.update(
      'workout_exercises',
      {
        'deleted_at': DateTime.now().millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'workout_id = ?',
      whereArgs: [workoutId],
    );
  }

  Future<List<WorkoutExercisesRow>> deleteExerciseFromWorkout({
    required String workoutId,
    required int exerciseId,
  }) async {
    final database = await db;
    await database.update(
      'workout_exercises',
      {
        'deleted_at': DateTime.now().millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'workout_id = ? AND exercise_id = ?',
      whereArgs: [workoutId, exerciseId],
    );
    final workoutExercisesResult = await database.query('workout_exercises',
        where: 'workout_id = ?', whereArgs: [workoutId]);
    return workoutExercisesResult
        .map((row) => WorkoutExercisesRow.fromDB(row))
        .toList();
  }
}
