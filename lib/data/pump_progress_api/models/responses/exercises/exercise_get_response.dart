import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise.dart';

@immutable
class ExerciseGetResponse {
  final List<Exercise> data;
  const ExerciseGetResponse({
    required this.data,
  });

  ExerciseGetResponse copyWith({
    List<Exercise>? data,
  }) {
    return ExerciseGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory ExerciseGetResponse.fromMap(Map<String, dynamic> map) {
    return ExerciseGetResponse(
      data: List<Exercise>.from(
          map['data']?.map((x) => Exercise.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseGetResponse.fromJson(String source) =>
      ExerciseGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ExerciseGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExerciseGetResponse && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
