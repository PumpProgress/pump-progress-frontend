# Calendar Day Detail — Enhanced View

**Date:** 2026-04-28  
**Status:** Approved

## Overview

Replace the flat exercise-name list below the calendar with a structured, informative day summary. When the user taps a day that has a workout, the section below the calendar shows three parts: a day stats bar, a muscle chips row, and per-exercise cards with individual set rows.

---

## UI Layout

### Section 1 — Day Summary Bar

A full-width amethyst (`PPColors.amethyst500`) bar with three stat columns separated by vertical dividers:

| Stat | Source |
|---|---|
| Exercises | `exerciseSummaries.length` |
| Total Sets | sum of `DayExerciseSummary.sets.length` across all exercises |
| Volume | sum of `reps × weight` across all sets, formatted as `X.Xk kg` when ≥ 1000 |

Shown only when a day is selected and has at least one exercise. Hidden when no day is selected.

### Section 2 — Sets by Muscle Chips

A horizontally-wrapping row of chips. Each chip shows:
- A small colored dot
- The muscle name
- The total set count for that muscle

Computed by iterating all `DayExerciseSummary` entries, expanding each `exercise.muscles` list, and summing the `sets.length` per muscle name. Uses `exercise.category` as fallback label when `muscles` is empty.

Chips use alternating colors from the amethyst and coral palettes.

### Section 3 — Exercise Cards

A `ListView` of cards, one per exercise. Each card contains:

**Header row:** exercise name (left) + category badge pill in `PPColors.amethyst400` (right).

**Column headers:** `Set` | `Reps` | `Weight` (grey, uppercase, small).

**Set rows:** one row per set, ordered by `createdAt` ASC:
- Set number in `PPColors.amethyst300`
- Reps right-aligned
- Weight right-aligned (e.g. `80 kg`)

**Footer row:** `Avg RPE` label + amethyst pill showing the average `intensity` across all sets for this exercise, rounded to one decimal. Hidden if all intensity values are 0 (user did not log RPE).

---

## Data Model Changes

### New domain class: `DayExerciseSummary`

Located at `lib/features/sets/domain/day_exercise_summary.dart`.

```
DayExerciseSummary {
  Exercise exercise
  List<ExerciseSetEntry> sets   // ordered by createdAt ASC

  double get avgRpe             // avg of set.intensity; returns 0.0 if all zero
  bool get hasRpe               // true if any set has intensity > 0
}
```

### New domain class: `ExerciseSetEntry`

Located in the same file or as a part of `day_exercise_summary.dart`.

```
ExerciseSetEntry {
  int repetitions
  double weight
  int intensity
}
```

### Updated `CalendarState`

Rename `setsAtDay` to `exerciseSummaries` with type `List<DayExerciseSummary>`. Default: `const []`.

---

## Repository Changes

### `RepositorySets.getExerciseSummariesByDate`

Replaces `getSetsByUserIdAndDate`. Steps:

1. Call `localSets.getSetsByUserIdAndDate(userId, date)` → `List<SetsRow>` (already exists).
2. Collect unique `exerciseId` values.
3. Call `localExercise.getExercises(exerciseIds)` → `List<ExerciseRow>`.
4. Build a map `exerciseId → Exercise`.
5. Group `SetsRow` list by `exerciseId`, preserving `createdAt` ASC order.
6. For each group, construct `DayExerciseSummary(exercise, sets: [ExerciseSetEntry...])`.
7. Return `List<DayExerciseSummary>`, ordered by the `createdAt` of the first set in each group.

No new SQL queries required — reuses existing local methods.

---

## BLoC Changes

### `CalendarBloc._onDaySelectedAtCalendar`

Call `repositorySets.getExerciseSummariesByDate` instead of `getSetsByUserIdAndDate`. Emit with `exerciseSummaries` field.

### `CalendarState`

- `setsAtDay: List<Exercise>` → `exerciseSummaries: List<DayExerciseSummary>`
- `copyWith` updated accordingly.

---

## Widget Changes

### `StartCalendarView`

The current `Expanded(ListView.builder(...))` at the bottom of the outer `Column` is replaced by:

```
Expanded(
  child: Column(
    children: [
      if (exerciseSummaries.isNotEmpty) _DayStatsSummaryWidget(...),
      if (exerciseSummaries.isNotEmpty) _MuscleSetsChipsWidget(...),
      Expanded(ListView.builder of _ExerciseCardWidget),
    ],
  ),
)
```

The outer `Expanded` is required so the inner `Column` can host its own `Expanded` child without unbounded-height errors.

The three new widgets are extracted to `lib/screens/main/tabs/calendar/view/widgets/` to match the existing `start_calendar_day_widget.dart` convention.

### `_DayStatsSummaryWidget`

Stateless. Takes `List<DayExerciseSummary>`. Computes exercises count, total sets, total volume inline.

### `_MuscleSetsChipsWidget`

Stateless. Takes `List<DayExerciseSummary>`. Aggregates muscle → set count and renders chips.

### `_ExerciseCardWidget`

Stateless. Takes a single `DayExerciseSummary`. Renders header, set rows, and RPE footer. RPE footer is omitted when `!summary.hasRpe`.

---

## Empty / Loading States

- When no day is selected: show a neutral placeholder text ("Select a day to see your workout").
- When a day is selected but has no sets: show "No workout logged for this day."
- Loading state: existing `CalendarStatusLoading` covers this — no change needed.

---

## Out of Scope

- Navigation from a card to the exercise detail screen.
- Editing sets from this view.
- Comparing the selected day to a previous session.
