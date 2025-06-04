import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';
import 'package:pump_progress_frontend/repositories/models/models.dart';

class PumpProgressRepository {
  // TODO singleton
  PumpProgressRepository();
  final pumpProgressApiProvider = PumpProgressApiProvider();

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

  Future<void> deleteUser(String userId) async {
    await pumpProgressApiProvider.deleteUser(userId);
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
    return Series.fromJson(data.toJson());
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

    return Series.fromJson(data.toJson());
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
    return Workout.fromJson(data.toJson());
  }

  Future<Workout> putAddWorkoutExercise({
    required String workoutId,
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.putAddWorkoutExercise(
      workoutId: workoutId,
      body: WorkoutPutUpdateExerciseBody(exerciseId: exerciseId),
    );
    return Workout.fromJson(data.toJson());
  }

  Future<Workout> putRemoveWorkoutExercise({
    required String workoutId,
    required String exerciseId,
  }) async {
    final data = await pumpProgressApiProvider.putRemoveWorkoutExercise(
      workoutId: workoutId,
      body: WorkoutPutUpdateExerciseBody(exerciseId: exerciseId),
    );
    return Workout.fromJson(data.toJson());
  }

  Future<List<UserSeries>> getSeriesByDate({
    required String userId,
    required DateTime date,
  }) async {
    final data =
        await pumpProgressApiProvider.getSetsByDate(userId: userId, date: date);
    final exercises =
        data.sets.map((e) => UserSeries.fromJson(e.toJson())).toList();
    return exercises;
  }

  Future<List<WorkoutSession>> getWorkoutSessions(
      {int? limit, int? offset}) async {
    final data = await pumpProgressApiProvider.getWorkoutSessions(
        limit: limit, offset: offset);
    final workoutSessions =
        data.data.map((e) => WorkoutSession.fromAPI(e)).toList();
    return workoutSessions;
  }
}
