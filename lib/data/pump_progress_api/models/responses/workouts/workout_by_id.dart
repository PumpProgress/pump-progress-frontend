// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/workouts/exercises_at_workout_api.dart';

class WorkoutPopulatedDto {
  final String id;
  final String name;
  final String userId;
  final List<ExerciseAtWorkoutAPI> exercises;

  WorkoutPopulatedDto({
    required this.id,
    required this.name,
    required this.userId,
    required this.exercises,
  });

  WorkoutPopulatedDto copyWith({
    String? id,
    String? name,
    String? userId,
    List<ExerciseAtWorkoutAPI>? exercises,
  }) {
    return WorkoutPopulatedDto(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userId': userId,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'exercisesCount': exercises.length,
    };
  }

  factory WorkoutPopulatedDto.fromMap(Map<String, dynamic> map) {
    return WorkoutPopulatedDto(
      id: map['id'] as String,
      name: map['name'] as String,
      userId: map['userId'] as String,
      exercises: List<ExerciseAtWorkoutAPI>.from(
        (map['exercises'] as List<dynamic>).map<ExerciseAtWorkoutAPI>(
          (x) => ExerciseAtWorkoutAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPopulatedDto.fromJson(String source) =>
      WorkoutPopulatedDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutPopulatedDto(id: $id, name: $name, userId: $userId, exercises: $exercises)';
  }

  @override
  bool operator ==(covariant WorkoutPopulatedDto other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.userId == userId &&
        listEquals(other.exercises, exercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ userId.hashCode ^ exercises.hashCode;
  }
}
