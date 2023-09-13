import 'dart:convert';

import 'package:flutter/foundation.dart';

class WorkoutAPI {
  final String id;
  final String name;
  final String userId;
  final List<String> exercises;
  WorkoutAPI({
    required this.id,
    required this.name,
    required this.userId,
    required this.exercises,
  });

  WorkoutAPI copyWith({
    String? id,
    String? name,
    String? userId,
    List<String>? exercises,
  }) {
    return WorkoutAPI(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'exercises': exercises,
    };
  }

  factory WorkoutAPI.fromMap(Map<String, dynamic> map) {
    return WorkoutAPI(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
      exercises: List<String>.from(map['exercises']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutAPI.fromJson(String source) =>
      WorkoutAPI.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WorkoutAPI(id: $id, name: $name, userId: $userId, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutAPI &&
        other.id == id &&
        other.name == name &&
        other.userId == userId &&
        listEquals(other.exercises, exercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ userId.hashCode ^ exercises.hashCode;
  }
}
