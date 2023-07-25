import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/auth_log_in/auth_log_in_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_sets_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_update_favorite_exercises_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_post_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_put_update_exercise_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workouts_api.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';

class PumpProgressRepository {
  PumpProgressRepository();
  final pumpProgressApiProvider = PumpProgressApiProvider();

  Future<String> authLogIn({
    required String email,
    required String password,
  }) async {
    final data = await pumpProgressApiProvider
        .authLogIn(AuthLogInBody(email: email, password: password));
    return data.data.data;
  }

  Future<List<Exercise>> getExercises() async {
    final data = await pumpProgressApiProvider.getExercises();

    final exercise =
        data.data.map((e) => Exercise.fromJson(e.toJson())).toList();
    return exercise;
  }

  Future<User> getMe() async {
    final data = await pumpProgressApiProvider.getMe();
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<List<Series>> getMySets(String? exerciseId) async {
    final data = await pumpProgressApiProvider.getMySets(exerciseId);

    final sets = data.data.map((e) => Series.fromJson(e.toJson())).toList();

    return sets;
  }

  Future<Series> postMySet({
    required String exerciseId,
    required int repetitions,
    required double weight,
  }) async {
    final data = await pumpProgressApiProvider.postMySet(MeSetBodyPost(
      exerciseId: exerciseId,
      repetitions: repetitions,
      weight: weight,
    ));
    final series = data.data;
    return Series.fromJson(series.toJson());
  }

  Future<User> postAddFavoriteExercise({
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.postAddFavoriteExercise(
      MeUpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<User> postRemoveFavoriteExercise({
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.postRemoveFavoriteExercise(
      MeUpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<List<Workout>> getWorkouts() async {
    final data = await pumpProgressApiProvider.getWorkouts();

    final workouts =
        data.data.map((e) => Workout.fromJson(e.toJson())).toList();

    return workouts;
  }

  Future<Workout> postWorkout({required String name}) async {
    final data =
        await pumpProgressApiProvider.postWorkout(WorkoutPostBody(name: name));
    final workout = data.data;
    return Workout.fromJson(workout.toJson());
  }

  Future<Workout> putAddWorkoutExercise({
    required String workoutId,
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.putAddWorkoutExercise(
      workoutId,
      WorkoutPutUpdateExerciseBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return Workout.fromJson(me.toJson());
  }

  Future<Workout> putRemoveWorkoutExercise({
    required String workoutId,
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.putRemoveWorkoutExercise(
      workoutId,
      WorkoutPutUpdateExerciseBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return Workout.fromJson(me.toJson());
  }
}
