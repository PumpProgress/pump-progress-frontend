import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';
import 'package:pump_progress_frontend/repositories/models/models.dart';

class PumpProgressRepository {
  // TODO singleton
  PumpProgressRepository();
  final pumpProgressApiProvider = PumpProgressApiProvider();

  // * auth
  @Deprecated("Use cognito for auth instead")
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

  // ? Refactored
  Future<User> getUser(String userId) async {
    final data = await pumpProgressApiProvider.getUser(userId);
    return User.fromJson(data.toJson());
  }

  Future<User> postUSerAddFavoriteExercise({
    required String exerciseId,
    required String userId,
  }) async {
    final data = await pumpProgressApiProvider.postUserAddFavoriteExercise(
      userId,
      UpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    return User.fromJson(data.toJson());
  }

  Future<User> postUserRemoveFavoriteExercise(
      {required String exerciseId, required String userId}) async {
    final data = await pumpProgressApiProvider.postUserRemoveFavoriteExercise(
      userId,
      UpdateFavoriteExercisesBody(exerciseId: exerciseId),
    );
    return User.fromJson(data.toJson());
  }

  Future<UserCalendar> getCalendarInfoByUserId(
      {required String userId, required int month, required int year}) async {
    final data = await pumpProgressApiProvider.getCalendarInfoByUserId(
        userId: userId, month: month, year: year);
    print("post getCalendarInfoByUserId provider: $data");
    return UserCalendar.fromJson(data.toJson());
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
