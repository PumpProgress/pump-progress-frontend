import 'package:pump_progress_frontend/features/workout/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';
import 'package:uuid/uuid.dart';

class LocalWorkout {
  final db = SqlDatabaseService.instance.database;

  Future<List<WorkoutRow>> getWorkouts({required String userId}) async {
    final database = await db;
    final workoutsResult = await database.query(
      'workouts',
      where: 'user_id = ? AND deleted_at IS NULL',
      whereArgs: [userId],
    );
    return workoutsResult.map((workout) => WorkoutRow.fromDB(workout)).toList();
  }

  Future<WorkoutRow> getWorkout({required String workoutId}) async {
    final database = await db;
    final workoutsResult = await database.query(
      'workouts',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [workoutId],
    );
    return workoutsResult.map((workout) => WorkoutRow.fromDB(workout)).first;
  }

  Future<WorkoutRow> createWorkout({
    required String userId,
    required String name,
  }) async {
    final id = const Uuid().v4();
    final workoutPayload = {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'is_dirty': 1,
    };

    final database = await db;
    await database.insert('workouts', workoutPayload);
    final workoutResult = await database
        .query('workouts', where: 'id = ?', whereArgs: [id.toString()]);
    return WorkoutRow.fromDB(workoutResult.first);
  }

  Future<void> deleteWorkout({required String workoutId}) async {
    final database = await db;
    await database.update(
      'workouts',
      {
        'deleted_at': DateTime.now().millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'id = ?',
      whereArgs: [workoutId],
    );
  }

  Future<WorkoutRow> updateWorkout(
      {required String workoutId, required String name}) async {
    final database = await db;
    await database.update(
      'workouts',
      {
        'name': name,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'id = ?',
      whereArgs: [workoutId],
    );
    final workoutResult = await database
        .query('workouts', where: 'id = ?', whereArgs: [workoutId]);
    return WorkoutRow.fromDB(workoutResult.first);
  }
}
