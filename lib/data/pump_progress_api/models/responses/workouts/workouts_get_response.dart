import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/workouts_api.dart';

class WorkoutsGetResponse {
  final List<WorkoutAPI> data;
  WorkoutsGetResponse({
    required this.data,
  });

  WorkoutsGetResponse copyWith({
    List<WorkoutAPI>? data,
  }) {
    return WorkoutsGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory WorkoutsGetResponse.fromMap(Map<String, dynamic> map) {
    return WorkoutsGetResponse(
      data:
          List<WorkoutAPI>.from(map['data']?.map((x) => WorkoutAPI.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutsGetResponse.fromJson(String source) =>
      WorkoutsGetResponse.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutsGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutsGetResponse && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
