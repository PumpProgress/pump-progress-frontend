import 'dart:convert';

class MeUpdateFavoriteExercisesBody {
  final String exerciseId;
  MeUpdateFavoriteExercisesBody({
    required this.exerciseId,
  });

  MeUpdateFavoriteExercisesBody copyWith({
    String? exerciseId,
  }) {
    return MeUpdateFavoriteExercisesBody(
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
    };
  }

  factory MeUpdateFavoriteExercisesBody.fromMap(Map<String, dynamic> map) {
    return MeUpdateFavoriteExercisesBody(
      exerciseId: map['exerciseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeUpdateFavoriteExercisesBody.fromJson(String source) =>
      MeUpdateFavoriteExercisesBody.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MeUpdateFavoriteExercisesBody(exerciseId: $exerciseId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeUpdateFavoriteExercisesBody &&
        other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => exerciseId.hashCode;
}
