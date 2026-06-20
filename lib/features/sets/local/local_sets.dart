import 'package:pump_progress_frontend/features/sets/models/entities/entities.dart';
import 'package:pump_progress_frontend/utils/services/sql_database_service/sql_database_service.dart';
import 'package:uuid/uuid.dart';

class LocalSets {
  final db = SqlDatabaseService.instance.database;

  Future<List<SetsRow>> getSeriesByExercise({
    required int exerciseId,
    required String userId,
  }) async {
    final database = await db;
    final seriesResult = await database.rawQuery('''SELECT * FROM sets 
        WHERE exercise_id = ? AND user_id = ? AND deleted_at IS NULL
        ''', [exerciseId, userId]);
    return seriesResult.map((series) => SetsRow.fromDB(series)).toList();
  }

  Future<SetsRow> createSeries({
    required int exerciseId,
    required int repetitions,
    required double weight,
    required String userId,
    int intensity = 0,
  }) async {
    final database = await db;

    final now = DateTime.now();
    final id = Uuid().v4();
    await database.insert('sets', {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'repetitions': repetitions,
      'weight': weight,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'intensity': intensity,
      'is_dirty': 1,
    });
    return SetsRow(
      id: id,
      userId: userId,
      exerciseId: exerciseId,
      createdAt: now,
      updatedAt: now,
      repetitions: repetitions,
      weight: weight,
      intensity: intensity,
    );
  }

  Future<SetsRow> updateSeries({
    required String seriesId,
    required int repetitions,
    required double weight,
    int intensity = 0,
  }) async {
    final database = await db;
    final now = DateTime.now();
    await database.update(
      'sets',
      {
        'repetitions': repetitions,
        'weight': weight,
        'intensity': intensity,
        'updated_at': now.millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'id = ?',
      whereArgs: [seriesId],
    );
    final result = await database.query(
      'sets',
      where: 'id = ?',
      whereArgs: [seriesId],
    );
    return SetsRow.fromDB(result.first);
  }

  Future<void> deleteSeries(String seriesId) async {
    final database = await db;
    final now = DateTime.now();
    await database.update(
      'sets',
      {
        'deleted_at': now.millisecondsSinceEpoch,
        'updated_at': now.millisecondsSinceEpoch,
        'is_dirty': 1,
      },
      where: 'id = ?',
      whereArgs: [seriesId],
    );
  }

  Future<List<ExerciseAnalyticsRow>> getExerciseAnalytics({
    required int exerciseId,
    required String userId,
    required String timeZoneOffset, // e.g. '+05:30' or '-05:00'
  }) async {
    final database = await db;

    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));

    final analyticsResult = await database.rawQuery('''
      SELECT
        DATE(created_at / 1000, 'unixepoch', ?) AS date,
        SUM(repetitions * weight) AS sessionVolume,
        COUNT(*) AS totalSets,
        SUM(repetitions) AS totalReps,
        CASE
          WHEN SUM(repetitions) > 0 THEN SUM(repetitions * weight) / SUM(repetitions)
          ELSE 0
        END AS avgWeightPerRep,
        MAX(weight) AS maxWeight,
        MIN(weight) AS minWeight
      FROM sets
      WHERE
        user_id = ?
        AND exercise_id = ?
        AND deleted_at IS NULL
        AND created_at >= ?
        AND created_at <= ?
      GROUP BY
        DATE(created_at / 1000, 'unixepoch', ?)
      ORDER BY
        date ASC;
    ''', [
      timeZoneOffset,
      userId,
      exerciseId,
      threeMonthsAgo.millisecondsSinceEpoch,
      now.millisecondsSinceEpoch,
      timeZoneOffset,
    ]);

    return analyticsResult
        .map((row) => ExerciseAnalyticsRow.fromDB(row))
        .toList();
  }

  Future<List<CalendarSeriesRow>> getCalendarInfoByUserId({
    required String userId,
    required int month,
    required int year,
  }) async {
    final database = await db;

    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(seconds: 1));

    final calendarInfoResult = await database.rawQuery('''
      SELECT
        DATE(created_at / 1000, 'unixepoch') AS date,
        COUNT(*) AS totalSets,
        SUM(repetitions) AS totalReps,
        SUM(repetitions * weight) AS totalVolume
      FROM sets
      WHERE
        user_id = ?
        AND deleted_at IS NULL
        AND created_at >= ?
        AND created_at <= ?
      GROUP BY
        DATE(created_at)
      ORDER BY
        date ASC
    ''', [
      userId,
      startOfMonth.millisecondsSinceEpoch,
      endOfMonth.millisecondsSinceEpoch,
    ]);

    return calendarInfoResult
        .map((row) => CalendarSeriesRow.fromDB(row))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getDaySetsWithExercise({
    required String userId,
    required DateTime date,
  }) async {
    final database = await db;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

    return database.rawQuery('''
      SELECT
        s.exercise_id,
        e.name AS exercise_name,
        ct.name AS category_name,
        s.repetitions,
        s.weight,
        s.intensity,
        s.created_at
      FROM sets s
      JOIN exercises e ON s.exercise_id = e.id
      LEFT JOIN category_types ct ON e.category_id = ct.id
      WHERE s.user_id = ?
        AND s.deleted_at IS NULL
        AND e.deleted_at IS NULL
        AND s.created_at >= ?
        AND s.created_at <= ?
      ORDER BY s.created_at ASC
    ''', [
      userId,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ]);
  }

  Future<Map<int, int>> getSeriesCountTodayByExercises({
    required String userId,
    required List<int> exerciseIds,
  }) async {
    if (exerciseIds.isEmpty) return {};
    final database = await db;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay =
        startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final placeholders = exerciseIds.map((_) => '?').join(', ');

    final result = await database.rawQuery('''
      SELECT exercise_id, COUNT(*) as count
      FROM sets
      WHERE user_id = ?
        AND exercise_id IN ($placeholders)
        AND deleted_at IS NULL
        AND created_at >= ?
        AND created_at <= ?
      GROUP BY exercise_id
    ''', [
      userId,
      ...exerciseIds,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ]);

    return Map.fromEntries(
      result.map((row) => MapEntry(
            row['exercise_id'] as int,
            row['count'] as int,
          )),
    );
  }

  Future<List<Map<String, dynamic>>> getMusclesForExercises({
    required List<int> exerciseIds,
  }) async {
    if (exerciseIds.isEmpty) return [];
    final database = await db;
    final placeholders = exerciseIds.map((_) => '?').join(',');
    return database.rawQuery('''
      SELECT e.id AS exercise_id, m.name AS muscle_name
      FROM exercises e
      JOIN muscles m ON e.primary_muscle_id = m.id
      WHERE e.id IN ($placeholders)
        AND e.primary_muscle_id IS NOT NULL
        AND e.deleted_at IS NULL
        AND m.deleted_at IS NULL
      UNION
      SELECT esm.exercise_id, m.name AS muscle_name
      FROM exercise_secondary_muscles esm
      JOIN muscles m ON esm.muscle_id = m.id
      WHERE esm.exercise_id IN ($placeholders)
        AND esm.deleted_at IS NULL
        AND m.deleted_at IS NULL
    ''', [...exerciseIds, ...exerciseIds]);
  }
}
