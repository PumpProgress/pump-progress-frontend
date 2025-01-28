part of 'workout_session.dart';

class WorkoutSessionSeriesExerciseAPI {
  final String id;
  final String name;
  WorkoutSessionSeriesExerciseAPI({
    required this.id,
    required this.name,
  });

  WorkoutSessionSeriesExerciseAPI copyWith({
    String? id,
    String? name,
  }) {
    return WorkoutSessionSeriesExerciseAPI(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory WorkoutSessionSeriesExerciseAPI.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionSeriesExerciseAPI(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSessionSeriesExerciseAPI.fromJson(String source) =>
      WorkoutSessionSeriesExerciseAPI.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WorkoutSessionSeriesExerciseAPI(id: $id, name: $name)';

  @override
  bool operator ==(covariant WorkoutSessionSeriesExerciseAPI other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
