import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/local/local.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/local/local.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';

class RepositorySets {
  final LocalSets localSets = LocalSets();
  final LocalExercise localExercise = LocalExercise();

  Future<List<Series>> getSeriesByExercise({
    required int exerciseId,
    required String userId,
  }) async {
    final seriesRows = await localSets.getSeriesByExercise(
      exerciseId: exerciseId,
      userId: userId,
    );
    return seriesRows.map((row) => Series.fromMap(row.toMap())).toList();
  }

  Future<Series> createSeries({
    required int exerciseId,
    required int repetitions,
    required double weight,
    int? intensity,
    required String userId,
  }) async {
    final seriesRow = await localSets.createSeries(
      exerciseId: exerciseId,
      repetitions: repetitions,
      weight: weight,
      intensity: intensity ?? 0,
      userId: userId,
    );
    return Series.fromMap(seriesRow.toMap());
  }

  Future<Series> updateSeries({
    required String seriesId,
    required int repetitions,
    required double weight,
    int? intensity,
  }) async {
    final updatedSeriesRow = await localSets.updateSeries(
      seriesId: seriesId,
      repetitions: repetitions,
      weight: weight,
      intensity: intensity ?? 0,
    );
    return Series.fromMap(updatedSeriesRow.toMap());
  }

  Future<void> deleteSeries({required String seriesId}) async {
    await localSets.deleteSeries(seriesId);
  }

  Future<List<ExerciseAnalytics>> getExerciseAnalytics({
    required int exerciseId,
    required String userId,
  }) async {
    final analyticsRows = await localSets.getExerciseAnalytics(
      exerciseId: exerciseId,
      userId: userId,
      timeZoneOffset: DateTime.now().timeZoneOffset.isNegative
          ? '-${DateTime.now().timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:${(DateTime.now().timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0')}'
          : '+${DateTime.now().timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:${(DateTime.now().timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0')}',
    );
    return analyticsRows
        .map((row) => ExerciseAnalytics.fromMap(row.toMap()))
        .toList();
  }

  Future<CalendarSeries> getCalendarInfoByUserId({
    required String userId,
    required int month,
    required int year,
  }) async {
    final calendarInfoRows = await localSets.getCalendarInfoByUserId(
      userId: userId,
      month: month,
      year: year,
    );
    final Map<String, dynamic> dates;
    // for each calednarInfoRow add an entro to dates
    if (calendarInfoRows.isEmpty) {
      dates = {};
    } else {
      dates = calendarInfoRows.fold({}, (acc, row) {
        final dateKey = row.date;
        if (acc.containsKey(dateKey)) {
          AppLogger.debug('Duplicate date key found: $dateKey.');
        } else {
          acc[dateKey] = [row];
        }
        return acc;
      });
    }
    return CalendarSeries(dates: dates);
  }

  Future<List<Exercise>> getSetsByUserIdAndDate({
    required String userId,
    required DateTime date,
  }) async {
    final setsRows = await localSets.getSetsByUserIdAndDate(
      userId: userId,
      date: date,
    );
    final Set<int> exerciseIds = setsRows.map((row) => row.exerciseId).toSet();
    final exerciseRows = await localExercise.getExercises(
      exerciseIds: exerciseIds.toList(),
    );
    final exercises = exerciseRows
        .map((exerciseRow) => Exercise.fromMap(exerciseRow.toMap()))
        .toList();
    return exercises;
  }
}
