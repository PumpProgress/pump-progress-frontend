import 'package:dio/dio.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/auth_log_in/auth_log_in_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_sets_body_post.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/requests/me/me_update_favorite_exercises_body.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/auth_log_in/auth_log_in_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_set_post_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_sets_get_response.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_sets_update_favorite_response.dart';
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
    } on DioError catch (error, stackTrace) {
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
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  // * me

  Future<MeGetResponse> getMe() async {
    try {
      final response = await dioClient.dio.get<String>(
        '/me',
      );
      return MeGetResponse.fromJson(response.data!);
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<MeSetsGetResponse> getMySets(String? exerciseId) async {
    try {
      const baseURL = '/me/sets';
      // Set the query parameter(s)
      final queryParameters = {
        'exerciseId': exerciseId,
      };

      // Modify the URL with the query parameters
      final url = Uri.parse(baseURL)
          .replace(queryParameters: queryParameters)
          .toString();

      final response = await dioClient.dio.get<String>(
        url,
      );
      return MeSetsGetResponse.fromJson(response.data!);
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<MeSetPostResponse> postMySet(MeSetBodyPost body) async {
    try {
      final response =
          await dioClient.dio.post<String>('/me/sets', data: body.toJson());
      return MeSetPostResponse.fromJson(response.data!);
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<MeUpdateFavoriteExercisesPostResponse> postAddFavoriteExercise(
    MeUpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await dioClient.dio
          .post<String>('/me/add-favorite-exercise', data: body.toJson());
      return MeUpdateFavoriteExercisesPostResponse.fromJson(response.data!);
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }

  Future<MeUpdateFavoriteExercisesPostResponse> postRemoveFavoriteExercise(
    MeUpdateFavoriteExercisesBody body,
  ) async {
    try {
      final response = await dioClient.dio
          .post<String>('/me/remove-favorite-exercise', data: body.toJson());
      return MeUpdateFavoriteExercisesPostResponse.fromJson(response.data!);
    } on DioError catch (error, stackTrace) {
      (error.error is GeneralException)
          ? throw error.error as GeneralException
          : throw GeneralException('An error ocurred', '000', stackTrace);
    }
  }
}
