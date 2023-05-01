import 'dart:convert';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me.dart';

class MeUpdateFavoriteExercisesPostResponse {
  final Me data;
  MeUpdateFavoriteExercisesPostResponse({
    required this.data,
  });

  MeUpdateFavoriteExercisesPostResponse copyWith({
    Me? data,
  }) {
    return MeUpdateFavoriteExercisesPostResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory MeUpdateFavoriteExercisesPostResponse.fromMap(
      Map<String, dynamic> map) {
    return MeUpdateFavoriteExercisesPostResponse(
      data: Me.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeUpdateFavoriteExercisesPostResponse.fromJson(String source) =>
      MeUpdateFavoriteExercisesPostResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MeUpdateFavoriteExercisesPostResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeUpdateFavoriteExercisesPostResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
