import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sync/exercise_row_api.dart';

class ExercisesGetResponse {
  final List<ExerciseRowAPI> data;
  ExercisesGetResponse({
    required this.data,
  });

  ExercisesGetResponse copyWith({
    List<ExerciseRowAPI>? data,
  }) {
    return ExercisesGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory ExercisesGetResponse.fromMap(Map<String, dynamic> map) {
    return ExercisesGetResponse(
      data: List<ExerciseRowAPI>.from(
        (map['data'] as List<dynamic>).map<ExerciseRowAPI>(
          (x) => ExerciseRowAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExercisesGetResponse.fromJson(String source) =>
      ExercisesGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ExercisesGetResponse(data: $data)';

  @override
  bool operator ==(covariant ExercisesGetResponse other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
