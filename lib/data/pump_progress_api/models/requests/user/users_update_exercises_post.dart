import 'dart:convert';

class UpdateFavoriteExercisesBody {
  final String exerciseId;

  UpdateFavoriteExercisesBody({
    required this.exerciseId,
  });

  UpdateFavoriteExercisesBody copyWith({
    String? exerciseId,
  }) {
    return UpdateFavoriteExercisesBody(
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
    };
  }

  factory UpdateFavoriteExercisesBody.fromMap(Map<String, dynamic> map) {
    return UpdateFavoriteExercisesBody(
      exerciseId: map['exerciseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateFavoriteExercisesBody.fromJson(String source) =>
      UpdateFavoriteExercisesBody.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UpdateFavoriteExercisesBody(exerciseId: $exerciseId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateFavoriteExercisesBody &&
        other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => exerciseId.hashCode;
}
