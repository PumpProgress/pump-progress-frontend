import 'dart:convert';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workouts_api.dart';

class WorkoutPostResponse {
  final WorkoutAPI data;
  WorkoutPostResponse({
    required this.data,
  });

  WorkoutPostResponse copyWith({
    WorkoutAPI? data,
  }) {
    return WorkoutPostResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory WorkoutPostResponse.fromMap(Map<String, dynamic> map) {
    return WorkoutPostResponse(
      data: WorkoutAPI.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPostResponse.fromJson(String source) =>
      WorkoutPostResponse.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutPostResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutPostResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
