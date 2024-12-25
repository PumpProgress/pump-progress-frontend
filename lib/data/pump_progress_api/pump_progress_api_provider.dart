import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/requests.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/responses.dart';
import 'package:pump_progress_frontend/utils/helpers/general_exception.dart';

import 'package:pump_progress_frontend/config/constants/flavor.dart';
import 'package:pump_progress_frontend/config/constants/local_storage.dart';
import 'package:pump_progress_frontend/utils/services/cognito_user_pool/cognito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pump_progress_api_client.dart';

class PumpProgressApiProvider {
  final ppApiClient = PumpProgressApiDio().client;
  static final PumpProgressApiProvider _singleton =
      PumpProgressApiProvider._internal();
  factory PumpProgressApiProvider() {
    return _singleton;
  }
  PumpProgressApiProvider._internal();

  // * auth

  Future<AuthLogInResponse> authLogIn(AuthLogInBody body) async {
    try {
      final response =
          await ppApiClient.post<String>('/auth/log-in', data: body.toJson());

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
      final response = await ppApiClient.get<String>(
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
      final response = await ppApiClient
          .post<String>('/me/remove-favorite-exercise', data: body.toJson());
      return MeUpdateFavoriteExercisesPostResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * users

  // ? Refactored
  // TODO: test bad requests handling the error en create the general exception with accurate data
  Future<UserAPI> getUser(String userId) async {
    try {
      final response = await ppApiClient.get(
        '/users/$userId',
      );
      return UserAPI.fromMap(response.data!);
    } on DioException catch (error, stackTrace) {
      print(error.toString());
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserAPI> postUserAddFavoriteExercise(
    String userId,
    UpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await ppApiClient.post<String>(
          '/users/$userId/add-favorite-exercise',
          data: body.toJson());
      return UserAPI.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserAPI> postUserRemoveFavoriteExercise(
    String userId,
    UpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await ppApiClient.post<String>(
          '/users/$userId/remove-favorite-exercise',
          data: body.toJson());
      return UserAPI.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<UserCalendarAPI> getCalendarInfoByUserId(
      {required String userId, required int month, required int year}) async {
    try {
      final response = await ppApiClient
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

      final response = await ppApiClient.get<String>(
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
          await ppApiClient.post<String>('/sets', data: body.toJson());
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
      final response =
          await ppApiClient.put<String>('/sets/$seriesId', data: body.toJson());
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

      final response = await ppApiClient.get<String>(url);
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
          await ppApiClient.post<String>('/workouts', data: body.toJson());
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
      final response = await ppApiClient.put<String>(url, data: body.toJson());
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
      final response = await ppApiClient.put<String>(url, data: body.toJson());
      return WorkoutPutUpdateExerciseResponse.fromJson(response.data!);
    } on DioException catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }
}
