// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/responses.dart';

class WorkoutSessionGetResponse {
  final List<WorkoutSessionAPI> data;
  WorkoutSessionGetResponse({
    required this.data,
  });

  WorkoutSessionGetResponse copyWith({
    List<WorkoutSessionAPI>? data,
  }) {
    return WorkoutSessionGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory WorkoutSessionGetResponse.fromMap(Map<String, dynamic> map) {
    print('WorkoutSessionGetResponse.fromMap: $map');
    return WorkoutSessionGetResponse(
      data: List<WorkoutSessionAPI>.from(
        (map['data'] as List<dynamic>).map<WorkoutSessionAPI>(
          (x) => WorkoutSessionAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSessionGetResponse.fromJson(String source) =>
      WorkoutSessionGetResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WorkoutSessionGetResponse(data: $data)';

  @override
  bool operator ==(covariant WorkoutSessionGetResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
