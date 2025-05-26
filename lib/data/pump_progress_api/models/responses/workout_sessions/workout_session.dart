// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
part 'workout_session_series.dart';
part 'workout_session_user.dart';
part 'workout_session_series_exercise.dart';

class WorkoutSessionAPI {
  final String id;
  final DateTime createdAt;
  final DateTime endedAt;
  final List<WorkoutSessionSeriesAPI> sets;
  final WorkoutSessionUserAPI user;
  WorkoutSessionAPI({
    required this.endedAt,
    required this.id,
    required this.sets,
    required this.createdAt,
    required this.user,
  });

  WorkoutSessionAPI copyWith({
    DateTime? endedAt,
    String? id,
    List<WorkoutSessionSeriesAPI>? sets,
    DateTime? createdAt,
    WorkoutSessionUserAPI? user,
  }) {
    return WorkoutSessionAPI(
      endedAt: endedAt ?? this.endedAt,
      id: id ?? this.id,
      sets: sets ?? this.sets,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'endedAt': endedAt.millisecondsSinceEpoch,
      'id': id,
      'sets': sets.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'user': user.toMap(),
    };
  }

  factory WorkoutSessionAPI.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionAPI(
      endedAt: DateTime.fromMillisecondsSinceEpoch(map['endedAt'] as int),
      id: map['id'] as String,
      sets: List<WorkoutSessionSeriesAPI>.from(
        (map['sets'] as List<dynamic>).map<WorkoutSessionSeriesAPI>(
          (x) => WorkoutSessionSeriesAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      user: WorkoutSessionUserAPI.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSessionAPI.fromJson(String source) =>
      WorkoutSessionAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutSessionAPI(endedAt: $endedAt, id: $id, sets: $sets, createdAt: $createdAt, user: $user)';
  }

  @override
  bool operator ==(covariant WorkoutSessionAPI other) {
    if (identical(this, other)) return true;

    return other.endedAt == endedAt &&
        other.id == id &&
        listEquals(other.sets, sets) &&
        other.createdAt == createdAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return endedAt.hashCode ^
        id.hashCode ^
        sets.hashCode ^
        createdAt.hashCode ^
        user.hashCode;
  }
}
