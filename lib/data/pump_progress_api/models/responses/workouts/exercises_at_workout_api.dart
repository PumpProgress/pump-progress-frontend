// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise_api.dart';

class ExerciseAtWorkoutAPI {
  final ExerciseAPI exercise;
  final int seriesToday;

  ExerciseAtWorkoutAPI({
    required this.exercise,
    required this.seriesToday,
  });

  ExerciseAtWorkoutAPI copyWith({
    ExerciseAPI? exercise,
    int? seriesToday,
  }) {
    return ExerciseAtWorkoutAPI(
      exercise: exercise ?? this.exercise,
      seriesToday: seriesToday ?? this.seriesToday,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exercise': exercise.toMap(),
      'seriesToday': seriesToday,
    };
  }

  factory ExerciseAtWorkoutAPI.fromMap(Map<String, dynamic> map) {
    return ExerciseAtWorkoutAPI(
      exercise: ExerciseAPI.fromMap(map['exercise'] as Map<String, dynamic>),
      seriesToday: map['seriesToday'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAtWorkoutAPI.fromJson(String source) =>
      ExerciseAtWorkoutAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExerciseAtWorkoutAPI(exercise: $exercise, seriesToday: $seriesToday)';

  @override
  bool operator ==(covariant ExerciseAtWorkoutAPI other) {
    if (identical(this, other)) return true;

    return other.exercise == exercise && other.seriesToday == seriesToday;
  }

  @override
  int get hashCode => exercise.hashCode ^ seriesToday.hashCode;
}
