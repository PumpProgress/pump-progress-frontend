part of 'workout_session.dart';

class WorkoutSessionSeriesAPI {
  final WorkoutSessionSeriesExerciseAPI exercise;
  final String id;
  final int repetitions;
  final double weight;
  WorkoutSessionSeriesAPI({
    required this.exercise,
    required this.id,
    required this.repetitions,
    required this.weight,
  });

  WorkoutSessionSeriesAPI copyWith({
    WorkoutSessionSeriesExerciseAPI? exercise,
    String? id,
    int? repetitions,
    double? weight,
  }) {
    return WorkoutSessionSeriesAPI(
      exercise: exercise ?? this.exercise,
      id: id ?? this.id,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exercise': exercise.toMap(),
      'id': id,
      'repetitions': repetitions,
      'weight': weight,
    };
  }

  factory WorkoutSessionSeriesAPI.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionSeriesAPI(
      exercise: WorkoutSessionSeriesExerciseAPI.fromMap(
          map['exercise'] as Map<String, dynamic>),
      id: map['id'] as String,
      repetitions: map['repetitions'] as int,
      weight: map['weight'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSessionSeriesAPI.fromJson(String source) =>
      WorkoutSessionSeriesAPI.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutSessionSeriesAPI(exercise: $exercise, id: $id, repetitions: $repetitions, weight: $weight)';
  }

  @override
  bool operator ==(covariant WorkoutSessionSeriesAPI other) {
    if (identical(this, other)) return true;

    return other.exercise == exercise &&
        other.id == id &&
        other.repetitions == repetitions &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return exercise.hashCode ^
        id.hashCode ^
        repetitions.hashCode ^
        weight.hashCode;
  }
}
