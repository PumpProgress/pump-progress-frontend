// import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';

// class WorkoutSession {
//   final WorkoutSessionUser user;
//   final List<WorkoutSessionExercise> exercises;
//   final DateTime createdAt;
//   final DateTime endedAt;
//   final String id;

//   WorkoutSession({
//     required this.user,
//     required this.exercises,
//     required this.createdAt,
//     required this.endedAt,
//     required this.id,
//   });

//   // constructor from WorkoutSessionAPI
//   factory WorkoutSession.fromAPI(WorkoutSessionAPI workoutSessionAPI) {
//     final Map<String, List<WorkoutSessionSeries>> reps = {};
//     final Map<String, String> exercisesNames = {};

//     for (var series in workoutSessionAPI.sets) {
//       if (reps.containsKey(series.exercise.id)) {
//         reps[series.exercise.id]!.add(WorkoutSessionSeries(
//           repetitions: series.repetitions,
//           weight: series.weight,
//         ));
//       } else {
//         reps[series.exercise.id] = [
//           WorkoutSessionSeries(
//             repetitions: series.repetitions,
//             weight: series.weight,
//           )
//         ];
//         exercisesNames[series.exercise.id] = series.exercise.name;
//       }
//     }

//     final List<WorkoutSessionExercise> exercises = reps.entries
//         .map((entry) => WorkoutSessionExercise(
//               id: entry.key,
//               name: exercisesNames[entry.key]!,
//               sets: entry.value,
//             ))
//         .toList();

//     return WorkoutSession(
//       user: WorkoutSessionUser(
//         id: workoutSessionAPI.user.id,
//         name: workoutSessionAPI.user.name,
//         email: workoutSessionAPI.user.email,
//       ),
//       exercises: exercises,
//       createdAt: workoutSessionAPI.createdAt,
//       endedAt: workoutSessionAPI.endedAt,
//       id: workoutSessionAPI.id,
//     );
//   }
// }

// class WorkoutSessionExercise {
//   final String id;
//   final String name;
//   final List<WorkoutSessionSeries> sets;

//   WorkoutSessionExercise({
//     required this.id,
//     required this.name,
//     required this.sets,
//   });
// }

// class WorkoutSessionSeries {
//   final int repetitions;
//   final double weight;

//   WorkoutSessionSeries({
//     required this.repetitions,
//     required this.weight,
//   });
// }

// class WorkoutSessionUser {
//   final String id;
//   final String name;
//   final String email;

//   WorkoutSessionUser({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
// }
