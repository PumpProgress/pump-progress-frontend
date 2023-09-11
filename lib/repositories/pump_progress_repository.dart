import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/auth_log_in/auth_log_in_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_sets_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_update_favorite_exercises_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/sets/series_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/sets/series_body_put.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/user/users_update_exercises_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_post_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_put_update_exercise_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';

class PumpProgressRepository {
  PumpProgressRepository();
  final pumpProgressApiProvider = PumpProgressApiProvider();

  // * auth
  Future<String> authLogIn({
    required String email,
    required String password,
  }) async {
    final data = await pumpProgressApiProvider
        .authLogIn(AuthLogInBody(email: email, password: password));
    return data.data.data;
  }

// * exercises
  Future<List<Exercise>> getExercises() async {
    final data = await pumpProgressApiProvider.getExercises();

    final exercise =
        data.data.map((e) => Exercise.fromJson(e.toJson())).toList();
    return exercise;
  }

// * users
  Future<User> getUser(String userId) async {
    final data = await pumpProgressApiProvider.getUser(userId);
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<User> postUSerAddFavoriteExercise({
    required String exerciseId,
    required String userId,
  }) async {
    final data = await pumpProgressApiProvider.postUserAddFavoriteExercise(
      userId,
      UpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<User> postUserRemoveFavoriteExercise(
      {required String exerciseId, required String userId}) async {
    final data = await pumpProgressApiProvider.postUserRemoveFavoriteExercise(
      userId,
      UpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    final me = data.data;
    return User.fromJson(me.toJson());
  }

// * sets
  Future<List<Series>> getSets({String? exerciseId, String? userId}) async {
    final data = await pumpProgressApiProvider.getSets(
        exerciseId: exerciseId, userId: userId);

    final sets = data.data.map((e) => Series.fromJson(e.toJson())).toList();

    return sets;
  }

  Future<Series> postSeries({
    required String exerciseId,
    required int repetitions,
    required double weight,
  }) async {
    final data = await pumpProgressApiProvider.postSeries(SeriesBodyPost(
      exerciseId: exerciseId,
      repetitions: repetitions,
      weight: weight,
    ));
    final series = data.data;
    return Series.fromJson(series.toJson());
  }

  Future<Series> putSeries({
    required String seriesId,
    required int repetitions,
    required double weight,
  }) async {
    final data = await pumpProgressApiProvider.putSeries(
        seriesId: seriesId,
        body: SeriesBodyPut(
          repetitions: repetitions,
          weight: weight,
        ));
    final series = data.data;
    return Series.fromJson(series.toJson());
  }

// * workouts

  Future<List<Workout>> getWorkouts({String? userId}) async {
    final data = await pumpProgressApiProvider.getWorkouts(userId: userId);

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
