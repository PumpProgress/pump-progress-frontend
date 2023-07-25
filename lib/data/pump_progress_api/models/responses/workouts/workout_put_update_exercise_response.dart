import 'dart:convert';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workouts_api.dart';

class WorkoutPutUpdateExerciseResponse {
  final WorkoutAPI data;
  WorkoutPutUpdateExerciseResponse({
    required this.data,
  });

  WorkoutPutUpdateExerciseResponse copyWith({
    WorkoutAPI? data,
  }) {
    return WorkoutPutUpdateExerciseResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory WorkoutPutUpdateExerciseResponse.fromMap(Map<String, dynamic> map) {
    return WorkoutPutUpdateExerciseResponse(
      data: WorkoutAPI.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPutUpdateExerciseResponse.fromJson(String source) =>
      WorkoutPutUpdateExerciseResponse.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutPutUpdateExerciseResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutPutUpdateExerciseResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
