import 'dart:convert';

import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';

class ExerciseAtWorkout {
  final Exercise exercise;
  final int seriesToday;

  ExerciseAtWorkout({
    required this.exercise,
    this.seriesToday = 0,
  });

  ExerciseAtWorkout copyWith({
    Exercise? exercise,
    int? seriesToday,
  }) {
    return ExerciseAtWorkout(
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

  factory ExerciseAtWorkout.fromMap(Map<String, dynamic> map) {
    return ExerciseAtWorkout(
      exercise: Exercise.fromMap(map['exercise'] as Map<String, dynamic>),
      seriesToday: map['seriesToday'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAtWorkout.fromJson(String source) =>
      ExerciseAtWorkout.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExerciseAtWorkout(exercise: $exercise, seriesToday: $seriesToday)';

  @override
  bool operator ==(covariant ExerciseAtWorkout other) {
    if (identical(this, other)) return true;

    return other.exercise == exercise && other.seriesToday == seriesToday;
  }

  @override
  int get hashCode => exercise.hashCode ^ seriesToday.hashCode;
}
