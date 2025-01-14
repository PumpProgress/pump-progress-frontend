import 'dart:convert';

// TODO this is a request body, not a response
class WorkoutPutUpdateExerciseBody {
  String exerciseId;
  WorkoutPutUpdateExerciseBody({
    required this.exerciseId,
  });

  WorkoutPutUpdateExerciseBody copyWith({
    String? exerciseId,
  }) {
    return WorkoutPutUpdateExerciseBody(
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
    };
  }

  factory WorkoutPutUpdateExerciseBody.fromMap(Map<String, dynamic> map) {
    return WorkoutPutUpdateExerciseBody(
      exerciseId: map['exerciseId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPutUpdateExerciseBody.fromJson(String source) =>
      WorkoutPutUpdateExerciseBody.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutPutUpdateExerciseBody(exerciseId: $exerciseId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutPutUpdateExerciseBody &&
        other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => exerciseId.hashCode;
}
