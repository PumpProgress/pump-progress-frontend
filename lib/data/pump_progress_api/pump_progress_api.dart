import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/auth_log_in/auth_log_in_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_update_favorite_exercises_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/sets/series_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/sets/series_body_put.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/user/users_update_exercises_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/auth_log_in/auth_log_in_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_sets_update_favorite_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sets/series_post_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sets/sets_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/users/user_calendar.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/users/user_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_post_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_post_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_put_update_exercise_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workout_put_update_exercise_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workouts_get_response.dart';
import 'package:pump_progress_frontend/utils/helpers/general_exception.dart';
import 'package:pump_progress_frontend/utils/services/dio_http_client.dart';

class PumpProgressApiProvider {
  PumpProgressApiProvider();

  final dioClient = PumpProgressApiDio();

  // * auth

  Future<AuthLogInResponse> authLogIn(AuthLogInBody body) async {
    try {
      final response =
          await dioClient.dio.post<String>('/auth/log-in', data: body.toJson());

      return AuthLogInResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * exercises

  Future<ExerciseGetResponse> getExercises() async {
    try {
      final response = await dioClient.dio.get<String>(
        '/exercises',
      );
      return ExerciseGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<MeUpdateFavoriteExercisesPostResponse> postMeRemoveFavoriteExercise(
    MeUpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await dioClient.dio
          .post<String>('/me/remove-favorite-exercise', data: body.toJson());
      return MeUpdateFavoriteExercisesPostResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * users

  Future<UserGetResponse> getUser(String userId) async {
    try {
      final response = await dioClient.dio.get<String>(
        '/users/$userId',
      );
      return UserGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      print(error.toString());
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserGetResponse> postUserAddFavoriteExercise(
    String userId,
    UpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await dioClient.dio.post<String>(
          '/users/$userId/add-favorite-exercise',
          data: body.toJson());
      return UserGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserGetResponse> postUserRemoveFavoriteExercise(
    String userId,
    UpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await dioClient.dio.post<String>(
          '/users/$userId/remove-favorite-exercise',
          data: body.toJson());
      return UserGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserCalendarAPI> getCalendarInfoByUserId(
      {required String userId, required int month, required int year}) async {
    try {
      final response = await dioClient.dio
          .get<String>('/users/$userId/calendar', queryParameters: {
        'month': month,
        'year': year,
      });
      print("response: ${response.data}");
      return UserCalendarAPI.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      print(error.toString());
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * sets

  Future<SetsGetResponse> getSets({String? exerciseId, String? userId}) async {
    try {
      const baseURL = '/sets';
      // Set the query parameter(s)
      final queryParameters = {
        'exerciseId': exerciseId,
        'userId': userId,
      };

      // Modify the URL with the query parameters
      final url = Uri.parse(baseURL)
          .replace(queryParameters: queryParameters)
          .toString();

      final response = await dioClient.dio.get<String>(
        url,
      );
      return SetsGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    } catch (err) {
      throw GeneralException('An error ocurred', '000', StackTrace.current);
    }
  }

  Future<SeriesPostResponse> postSeries(SeriesBodyPost body) async {
    try {
      final response =
          await dioClient.dio.post<String>('/sets', data: body.toJson());
      return SeriesPostResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<SeriesPostResponse> putSeries({
    required String seriesId,
    required SeriesBodyPut body,
  }) async {
    try {
      final response = await dioClient.dio
          .put<String>('/sets/$seriesId', data: body.toJson());
      return SeriesPostResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * workouts

  Future<WorkoutsGetResponse> getWorkouts({String? userId}) async {
    try {
      const baseURL = '/workouts';

      final queryParameters = {
        'userId': userId,
      };

      // Modify the URL with the query parameters
      final url = Uri.parse(baseURL)
          .replace(queryParameters: queryParameters)
          .toString();

      final response = await dioClient.dio.get<String>(url);
      return WorkoutsGetResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    } catch (err) {
      throw GeneralException('An error ocurred', '000', StackTrace.current);
    }
  }

  Future<WorkoutPostResponse> postWorkout(WorkoutPostBody body) async {
    try {
      final response =
          await dioClient.dio.post<String>('/workouts', data: body.toJson());
      return WorkoutPostResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<WorkoutPutUpdateExerciseResponse> putAddWorkoutExercise(
    String workoutId,
    WorkoutPutUpdateExerciseBody body,
  ) async {
    try {
      final url = '/workouts/$workoutId/add-exercise';
      final response =
          await dioClient.dio.put<String>(url, data: body.toJson());
      return WorkoutPutUpdateExerciseResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<WorkoutPutUpdateExerciseResponse> putRemoveWorkoutExercise(
    String workoutId,
    WorkoutPutUpdateExerciseBody body,
  ) async {
    try {
      final url = '/workouts/$workoutId/remove-exercise';
      final response =
          await dioClient.dio.put<String>(url, data: body.toJson());
      return WorkoutPutUpdateExerciseResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }
}
