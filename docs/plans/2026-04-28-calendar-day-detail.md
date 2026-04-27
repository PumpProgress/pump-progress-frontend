# Calendar Day Detail — Enhanced View Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the flat exercise-name list below the calendar with a day summary bar, muscle chips, and per-exercise cards showing individual set rows, avg RPE, and navigation to the exercise detail screen.

**Architecture:** Two new domain classes (`DayExerciseSummary`, `ExerciseSetEntry`) replace `List<Exercise>` in `CalendarState`. The repository fetches sets + exercise metadata via two SQL JOINs (sets + category name, then muscles per exercise) and assembles the domain objects. Three new stateless widgets (stats bar, muscle chips, exercise card) replace the current `ListView` in `StartCalendarView`.

**Tech Stack:** Flutter / Dart, flutter_bloc, sqflite (via `SqlDatabaseService`), table_calendar.

---

## File Map

### New files
| File | Responsibility |
|---|---|
| `lib/features/sets/domain/day_exercise_summary.dart` | `ExerciseSetEntry` and `DayExerciseSummary` domain classes |
| `lib/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart` | Top stats bar (exercises, sets, volume) |
| `lib/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart` | Muscle chips row |
| `lib/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart` | Per-exercise card with set rows, RPE, and tap navigation |
| `test/features/sets/domain/day_exercise_summary_test.dart` | Unit tests for domain model computed properties |

### Modified files
| File | Change |
|---|---|
| `lib/features/sets/domain/domain.dart` | Export `day_exercise_summary.dart` |
| `lib/features/sets/blocs/bloc_calendar/calendar_state.dart` | Replace `setsAtDay: List<Exercise>` with `exerciseSummaries: List<DayExerciseSummary>` |
| `lib/features/sets/blocs/bloc_calendar/calendar_bloc.dart` | Update import; update `_onDaySelectedAtCalendar` to call new repository method |
| `lib/features/sets/local/local_sets.dart` | Add `getDaySetsWithExercise` and `getMusclesForExercises` |
| `lib/features/sets/repositories/repository_sets.dart` | Add `getExerciseSummariesByDate`; remove unused `getSetsByUserIdAndDate` |
| `lib/screens/main/tabs/calendar/view/start_calendar_view.dart` | Wire new widgets; add empty/placeholder states |

---

### Task 1: Domain model

**Files:**
- Create: `lib/features/sets/domain/day_exercise_summary.dart`
- Create: `test/features/sets/domain/day_exercise_summary_test.dart`
- Modify: `lib/features/sets/domain/domain.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/features/sets/domain/day_exercise_summary_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/domain/day_exercise_summary.dart';

void main() {
  const exercise = Exercise(
    id: 1,
    name: 'Bench Press',
    category: 'Chest',
    muscles: ['Chest'],
  );

  group('DayExerciseSummary.avgRpe', () {
    test('returns 0.0 when sets is empty', () {
      final s = DayExerciseSummary(exercise: exercise, sets: const []);
      expect(s.avgRpe, 0.0);
    });

    test('returns average of intensity values', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 8),
          ExerciseSetEntry(repetitions: 8, weight: 80.0, intensity: 6),
        ],
      );
      expect(s.avgRpe, 7.0);
    });
  });

  group('DayExerciseSummary.hasRpe', () {
    test('returns false when all intensity values are 0', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 0),
        ],
      );
      expect(s.hasRpe, false);
    });

    test('returns true when any intensity value is > 0', () {
      final s = DayExerciseSummary(
        exercise: exercise,
        sets: const [
          ExerciseSetEntry(repetitions: 10, weight: 80.0, intensity: 0),
          ExerciseSetEntry(repetitions: 8, weight: 75.0, intensity: 7),
        ],
      );
      expect(s.hasRpe, true);
    });
  });
}
```

- [ ] **Step 2: Run — expect compile error**

```bash
fvm flutter test test/features/sets/domain/day_exercise_summary_test.dart
```

Expected: error — `day_exercise_summary.dart` not found.

- [ ] **Step 3: Create the domain file**

Create `lib/features/sets/domain/day_exercise_summary.dart`:

```dart
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

class ExerciseSetEntry {
  const ExerciseSetEntry({
    required this.repetitions,
    required this.weight,
    required this.intensity,
  });

  final int repetitions;
  final double weight;
  final int intensity;
}

class DayExerciseSummary {
  const DayExerciseSummary({
    required this.exercise,
    required this.sets,
  });

  final Exercise exercise;
  final List<ExerciseSetEntry> sets;

  double get avgRpe {
    if (sets.isEmpty) return 0.0;
    return sets.fold<int>(0, (sum, s) => sum + s.intensity) / sets.length;
  }

  bool get hasRpe => sets.any((s) => s.intensity > 0);
}
```

- [ ] **Step 4: Export from domain barrel**

Replace `lib/features/sets/domain/domain.dart` with:

```dart
export 'series.dart';
export 'exercise_analytics.dart';
export 'calendar_series.dart';
export 'day_exercise_summary.dart';
```

- [ ] **Step 5: Run tests — expect 4 passing**

```bash
fvm flutter test test/features/sets/domain/day_exercise_summary_test.dart
```

Expected: `+4: All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/sets/domain/day_exercise_summary.dart \
        lib/features/sets/domain/domain.dart \
        test/features/sets/domain/day_exercise_summary_test.dart
git commit -m "feat: add DayExerciseSummary domain model"
```

---

### Task 2: Update CalendarState and CalendarBloc

**Files:**
- Modify: `lib/features/sets/blocs/bloc_calendar/calendar_state.dart`
- Modify: `lib/features/sets/blocs/bloc_calendar/calendar_bloc.dart`

> Note: after this task `fvm flutter analyze` will report one error — `getExerciseSummariesByDate` does not exist on `RepositorySets` yet. That is expected and will be resolved in Task 4.

- [ ] **Step 1: Replace `calendar_state.dart`**

Full replacement of `lib/features/sets/blocs/bloc_calendar/calendar_state.dart`:

```dart
part of 'calendar_bloc.dart';

sealed class CalendarStatus {
  const CalendarStatus();
}

class CalendarStatusLoading extends CalendarStatus {
  const CalendarStatusLoading();
}

class CalendarStatusSuccess extends CalendarStatus {
  const CalendarStatusSuccess();
}

class CalendarStatusError extends ErrorStatus implements CalendarStatus {
  CalendarStatusError(super.errorMsg);
}

class CalendarState extends Equatable {
  const CalendarState({
    this.status = const CalendarStatusLoading(),
    this.userCalendar = CalendarSeries.empty,
    this.exerciseSummaries = const [],
  });

  final CalendarStatus status;
  final CalendarSeries userCalendar;
  final List<DayExerciseSummary> exerciseSummaries;

  CalendarState copyWith({
    CalendarStatus? status,
    CalendarSeries? userCalendar,
    List<DayExerciseSummary>? exerciseSummaries,
  }) {
    return CalendarState(
      status: status ?? this.status,
      userCalendar: userCalendar ?? this.userCalendar,
      exerciseSummaries: exerciseSummaries ?? this.exerciseSummaries,
    );
  }

  @override
  List<Object> get props => [status, userCalendar, exerciseSummaries];
}

final class CalendarInitial extends CalendarState {}
```

- [ ] **Step 2: Update `calendar_bloc.dart`**

Full replacement of `lib/features/sets/blocs/bloc_calendar/calendar_bloc.dart`:

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/utils/helpers/error_status.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required this.repositorySets}) : super(CalendarState()) {
    on<FetchSeriesByMonthEvent>(_onFetchSeriesByMonthEvent);
    on<DaySelectedAtCalendar>(_onDaySelectedAtCalendar);
  }
  final RepositorySets repositorySets;

  Future<void> _onFetchSeriesByMonthEvent(
      FetchSeriesByMonthEvent event, Emitter<CalendarState> emit) async {
    await runSafeEvent(emit, state, CalendarStatusError.new, () async {
      final userCalendar = await repositorySets.getCalendarInfoByUserId(
        userId: event.userId,
        month: event.month,
        year: event.year,
      );
      emit(state.copyWith(userCalendar: userCalendar));
    });
  }

  Future<void> _onDaySelectedAtCalendar(
      DaySelectedAtCalendar event, Emitter<CalendarState> emit) async {
    await runSafeEvent(emit, state, CalendarStatusError.new, () async {
      final summaries = await repositorySets.getExerciseSummariesByDate(
        userId: event.userId,
        date: event.day,
      );
      emit(state.copyWith(exerciseSummaries: summaries));
    });
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/sets/blocs/bloc_calendar/calendar_state.dart \
        lib/features/sets/blocs/bloc_calendar/calendar_bloc.dart
git commit -m "feat: update CalendarState and CalendarBloc for DayExerciseSummary"
```

---

### Task 3: Add SQL queries to LocalSets

**Files:**
- Modify: `lib/features/sets/local/local_sets.dart`

- [ ] **Step 1: Add `getDaySetsWithExercise`**

Append the following method before the closing `}` of the `LocalSets` class in `lib/features/sets/local/local_sets.dart`:

```dart
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
        AND s.created_at >= ?
        AND s.created_at <= ?
      ORDER BY s.created_at ASC
    ''', [
      userId,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ]);
  }
```

- [ ] **Step 2: Add `getMusclesForExercises`**

Append immediately after `getDaySetsWithExercise`, before the closing `}`:

```dart
  Future<List<Map<String, dynamic>>> getMusclesForExercises({
    required List<int> exerciseIds,
  }) async {
    if (exerciseIds.isEmpty) return [];
    final database = await db;
    final placeholders = exerciseIds.map((_) => '?').join(',');
    return database.rawQuery('''
      SELECT esm.exercise_id, m.name AS muscle_name
      FROM exercise_secondary_muscles esm
      JOIN muscles m ON esm.muscle_id = m.id
      WHERE esm.exercise_id IN ($placeholders)
        AND esm.deleted_at IS NULL
    ''', exerciseIds);
  }
```

- [ ] **Step 3: Verify the file compiles**

```bash
fvm flutter analyze lib/features/sets/local/local_sets.dart
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/sets/local/local_sets.dart
git commit -m "feat: add getDaySetsWithExercise and getMusclesForExercises to LocalSets"
```

---

### Task 4: Add repository method

**Files:**
- Modify: `lib/features/sets/repositories/repository_sets.dart`

- [ ] **Step 1: Add `getExerciseSummariesByDate` and remove `getSetsByUserIdAndDate`**

Full replacement of `lib/features/sets/repositories/repository_sets.dart`:

```dart
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

  Future<List<DayExerciseSummary>> getExerciseSummariesByDate({
    required String userId,
    required DateTime date,
  }) async {
    final rows =
        await localSets.getDaySetsWithExercise(userId: userId, date: date);
    if (rows.isEmpty) return [];

    final orderedIds = <int>[];
    final seenIds = <int>{};
    for (final row in rows) {
      final eid = row['exercise_id'] as int;
      if (seenIds.add(eid)) orderedIds.add(eid);
    }

    final muscleRows = await localSets.getMusclesForExercises(
        exerciseIds: orderedIds);

    final muscleMap = <int, List<String>>{};
    for (final mRow in muscleRows) {
      final eid = mRow['exercise_id'] as int;
      (muscleMap[eid] ??= []).add(mRow['muscle_name'] as String);
    }

    final grouped = <int, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final eid = row['exercise_id'] as int;
      (grouped[eid] ??= []).add(row);
    }

    return orderedIds.map((exerciseId) {
      final setRows = grouped[exerciseId]!;
      final exercise = Exercise(
        id: exerciseId,
        name: setRows.first['exercise_name'] as String,
        category: setRows.first['category_name'] as String? ?? '',
        muscles: muscleMap[exerciseId] ?? [],
      );
      final sets = setRows
          .map((r) => ExerciseSetEntry(
                repetitions: r['repetitions'] as int,
                weight: (r['weight'] as num).toDouble(),
                intensity: r['intensity'] as int,
              ))
          .toList();
      return DayExerciseSummary(exercise: exercise, sets: sets);
    }).toList();
  }
}
```

- [ ] **Step 2: Run full analyzer — expect zero errors**

```bash
fvm flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Run all tests**

```bash
fvm flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lib/features/sets/repositories/repository_sets.dart
git commit -m "feat: add getExerciseSummariesByDate to RepositorySets"
```

---

### Task 5: DayStatsSummaryWidget

**Files:**
- Create: `lib/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart`

- [ ] **Step 1: Create the widget**

```dart
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';

class DayStatsSummaryWidget extends StatelessWidget {
  const DayStatsSummaryWidget({super.key, required this.summaries});

  final List<DayExerciseSummary> summaries;

  @override
  Widget build(BuildContext context) {
    final totalSets =
        summaries.fold<int>(0, (sum, s) => sum + s.sets.length);
    final totalVolume = summaries.fold<double>(
      0.0,
      (sum, s) => sum +
          s.sets.fold<double>(
              0.0, (v, set) => v + set.repetitions * set.weight),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: PPColors.amethyst500,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(label: 'Exercises', value: '${summaries.length}'),
          const VerticalDivider(color: Color(0xFF5D3888), width: 1),
          _StatColumn(label: 'Total Sets', value: '$totalSets'),
          const VerticalDivider(color: Color(0xFF5D3888), width: 1),
          _StatColumn(label: 'Volume', value: _formatVolume(totalVolume)),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}k kg';
    return '${volume.toStringAsFixed(0)} kg';
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: PPColors.amethyst100,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: PPColors.neutral100,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Verify it compiles**

```bash
fvm flutter analyze lib/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart
git commit -m "feat: add DayStatsSummaryWidget"
```

---

### Task 6: MuscleSetsChipsWidget

**Files:**
- Create: `lib/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart`

- [ ] **Step 1: Create the widget**

```dart
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';

class MuscleSetsChipsWidget extends StatelessWidget {
  const MuscleSetsChipsWidget({super.key, required this.summaries});

  final List<DayExerciseSummary> summaries;

  static const _chipColors = [
    PPColors.amethyst400,
    PPColors.coral300,
    PPColors.amethyst300,
    PPColors.coral200,
  ];

  @override
  Widget build(BuildContext context) {
    final muscleSetCount = <String, int>{};
    for (final summary in summaries) {
      final labels = summary.exercise.muscles.isNotEmpty
          ? summary.exercise.muscles
          : [
              summary.exercise.category.isNotEmpty
                  ? summary.exercise.category
                  : 'Other',
            ];
      for (final label in labels) {
        muscleSetCount[label] =
            (muscleSetCount[label] ?? 0) + summary.sets.length;
      }
    }

    if (muscleSetCount.isEmpty) return const SizedBox.shrink();

    final entries = muscleSetCount.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SETS BY MUSCLE',
            style: TextStyle(
              color: PPColors.neutral300,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(entries.length, (i) {
              final color = _chipColors[i % _chipColors.length];
              return _MuscleChip(
                muscle: entries[i].key,
                setCount: entries[i].value,
                color: color,
              );
            }),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({
    required this.muscle,
    required this.setCount,
    required this.color,
  });
  final String muscle;
  final int setCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: PPColors.neutral500,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PPColors.neutral400, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            muscle,
            style: const TextStyle(color: PPColors.neutral100, fontSize: 13),
          ),
          const SizedBox(width: 6),
          Text(
            '$setCount sets',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles**

```bash
fvm flutter analyze lib/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart
git commit -m "feat: add MuscleSetsChipsWidget"
```

---

### Task 7: ExerciseCardWidget

**Files:**
- Create: `lib/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart`

- [ ] **Step 1: Create the widget**

```dart
import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/domain/domain.dart';
import 'package:pump_progress_frontend/screens/exercise/exercise_page.dart';

class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({super.key, required this.summary});

  final DayExerciseSummary summary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        PageExercise.routeName,
        arguments: ExercisesPageArguments(
          exerciseId: summary.exercise.id,
          exerciseName: summary.exercise.name,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    summary.exercise.name,
                    style: const TextStyle(
                      color: PPColors.neutral100,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (summary.exercise.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: PPColors.amethyst400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      summary.exercise.category,
                      style: const TextStyle(
                        color: PPColors.amethyst100,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text('SET',
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
                Expanded(
                  child: Text('REPS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
                Expanded(
                  child: Text('WEIGHT',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: PPColors.neutral400, fontSize: 10)),
                ),
              ],
            ),
            const Divider(color: Color(0xFF333333)),
            ...List.generate(summary.sets.length, (i) {
              final set = summary.sets[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: PPColors.amethyst300,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${set.repetitions}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: PPColors.neutral100, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatWeight(set.weight),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: PPColors.neutral100, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < summary.sets.length - 1)
                    const Divider(color: Color(0xFF333333), height: 1),
                ],
              );
            }),
            if (summary.hasRpe) ...[
              const Divider(color: PPColors.amethyst500),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Avg RPE',
                    style: TextStyle(
                        color: PPColors.neutral300, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: PPColors.amethyst500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      summary.avgRpe.toStringAsFixed(1),
                      style: const TextStyle(
                        color: PPColors.amethyst200,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatWeight(double weight) =>
      weight == weight.truncateToDouble()
          ? '${weight.toInt()} kg'
          : '$weight kg';
}
```

- [ ] **Step 2: Verify it compiles**

```bash
fvm flutter analyze lib/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart
git commit -m "feat: add ExerciseCardWidget with set rows, RPE, and navigation"
```

---

### Task 8: Wire StartCalendarView

**Files:**
- Modify: `lib/screens/main/tabs/calendar/view/start_calendar_view.dart`

- [ ] **Step 1: Replace the view file**

Full replacement of `lib/screens/main/tabs/calendar/view/start_calendar_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/day_stats_summary_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/exercise_card_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/muscle_sets_chips_widget.dart';
import 'package:pump_progress_frontend/screens/main/tabs/calendar/view/widgets/start_calendar_day_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class StartCalendarView extends StatefulWidget {
  const StartCalendarView({super.key});

  @override
  State<StartCalendarView> createState() => _StartCalendarViewState();
}

class _StartCalendarViewState extends State<StartCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final userId = context.read<UserSessionBloc>().state.user.id;
    context.read<CalendarBloc>().add(FetchSeriesByMonthEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserSessionBloc>().state.user.id;

    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.now().add(const Duration(days: 1)),
              focusedDay: _selectedDay ?? _focusedDay,
              headerVisible: true,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<CalendarBloc>().add(
                    DaySelectedAtCalendar(day: selectedDay, userId: userId));
              },
              onPageChanged: (focusedDay) {
                context.read<CalendarBloc>().add(FetchSeriesByMonthEvent(
                      year: focusedDay.year,
                      month: focusedDay.month,
                      userId: userId,
                    ));
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = null;
                });
              },
              eventLoader: (day) {
                return state.userCalendar
                        .dates[DateFormat('yyyy-MM-dd').format(day)] ??
                    [];
              },
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
              headerStyle: const HeaderStyle(titleCentered: true),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(child: Text(DateFormat.E().format(day)));
                },
                selectedBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  bgColor: PPColors.amethyst400,
                  textColor: PPColors.white,
                ),
                markerBuilder: (context, day, events) {
                  if (hasEvent(state.userCalendar.dates, day)) {
                    return StartCalendarDayWidget(
                      day: day,
                      textColor: isSameDay(_selectedDay, day)
                          ? PPColors.white
                          : PPColors.coral300,
                      bgColor: isSameDay(_selectedDay, day)
                          ? PPColors.coral300
                          : null,
                    );
                  }
                  return null;
                },
                todayBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  textColor: PPColors.amethyst300,
                ),
                defaultBuilder: (context, day, focusedDay) =>
                    StartCalendarDayWidget(
                  day: day,
                  textColor: PPColors.amethyst100,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (state.exerciseSummaries.isNotEmpty) ...[
                    DayStatsSummaryWidget(
                        summaries: state.exerciseSummaries),
                    MuscleSetsChipsWidget(
                        summaries: state.exerciseSummaries),
                  ],
                  Expanded(
                    child: _selectedDay == null
                        ? const Center(
                            child:
                                Text('Select a day to see your workout'),
                          )
                        : state.exerciseSummaries.isEmpty
                            ? const Center(
                                child: Text(
                                    'No workout logged for this day.'),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(bottom: 16),
                                itemCount: state.exerciseSummaries.length,
                                itemBuilder: (context, index) =>
                                    ExerciseCardWidget(
                                  summary:
                                      state.exerciseSummaries[index],
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

bool hasEvent(Map<String, dynamic> map, DateTime day) {
  final key = DateFormat('yyyy-MM-dd').format(day);
  return map.containsKey(key);
}
```

- [ ] **Step 2: Run full analyzer**

```bash
fvm flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Run all tests**

```bash
fvm flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lib/screens/main/tabs/calendar/view/start_calendar_view.dart
git commit -m "feat: wire calendar day detail enhanced view"
```
