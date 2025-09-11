// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/repositories/models/index.dart';

class Workout {
  final String id;
  final String name;
  final String userId;
  final List<ExerciseAtWorkout> exercises;
  final int exercisesCount;

  //* custom constructor
  const Workout.empty({
    this.id = '',
    this.name = '',
    this.userId = '',
    this.exercises = const <ExerciseAtWorkout>[],
    this.exercisesCount = 0,
  });

  const Workout({
    required this.id,
    required this.name,
    required this.userId,
    required this.exercises,
    required this.exercisesCount,
  });

  Workout copyWith({
    String? id,
    String? name,
    String? userId,
    List<ExerciseAtWorkout>? exercises,
    int? exercisesCount,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      exercises: exercises ?? this.exercises,
      exercisesCount: exercisesCount ?? this.exercisesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userId': userId,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'exercisesCount': exercisesCount,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as String,
      name: map['name'] as String,
      userId: map['userId'] as String,
      exercises: List<ExerciseAtWorkout>.from(
        (map['exercises'] as List<dynamic>).map<ExerciseAtWorkout>(
          (x) => ExerciseAtWorkout.fromMap(x as Map<String, dynamic>),
        ),
      ),
      exercisesCount: map['exercisesCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) =>
      Workout.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Workout(id: $id, name: $name, userId: $userId, exercises: $exercises, exercisesCount: $exercisesCount)';
  }

  @override
  bool operator ==(covariant Workout other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.userId == userId &&
        listEquals(other.exercises, exercises) &&
        other.exercisesCount == exercisesCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        userId.hashCode ^
        exercises.hashCode ^
        exercisesCount.hashCode;
  }
}
