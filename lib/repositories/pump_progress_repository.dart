import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/auth_log_in/auth_log_in_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_sets_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_update_favorite_exercises_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/pump_progress_api.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';
import 'package:pump_progress_frontend/repositories/models/user.dart';

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
    return data.data;
  }

  Future<User> getMe() async {
    final data = await pumpProgressApiProvider.getMe();
    final me = data.data;
    return User.fromJson(me.toJson());
  }

  Future<List<Series>> getMySets() async {
    final data = await pumpProgressApiProvider.getMySets();

    List<Series> sets =
        data.data.map((e) => Series.fromJson(e.toJson())).toList();

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
}
