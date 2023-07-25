import 'dart:convert';

import 'package:flutter/foundation.dart';

class Workout {
  final String id;
  final String name;
  final String userId;
  final List<String> exercises;

  const Workout({
    required this.id,
    required this.name,
    required this.userId,
    required this.exercises,
  });

  Workout copyWith({
    String? id,
    String? name,
    String? userId,
    List<String>? exercises,
  }) {
    return Workout(
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

  const Workout.empty({
    this.id = '',
    this.name = '',
    this.userId = '',
    this.exercises = const <String>[],
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
      exercises: List<String>.from(map['exercises']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) =>
      Workout.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Workout(id: $id, name: $name, userId: $userId, exercises: $exercises)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Workout &&
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
