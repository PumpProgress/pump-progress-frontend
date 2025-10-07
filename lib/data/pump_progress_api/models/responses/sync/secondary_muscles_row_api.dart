import 'dart:convert';

class SecondaryMusclesRowAPI {
  final int exerciseId;
  final int muscleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  SecondaryMusclesRowAPI({
    required this.exerciseId,
    required this.muscleId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  SecondaryMusclesRowAPI copyWith({
    int? exerciseId,
    int? muscleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return SecondaryMusclesRowAPI(
      exerciseId: exerciseId ?? this.exerciseId,
      muscleId: muscleId ?? this.muscleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
      'muscleId': muscleId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'exercise_id': exerciseId,
      'muscle_id': muscleId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory SecondaryMusclesRowAPI.fromMap(Map<String, dynamic> map) {
    return SecondaryMusclesRowAPI(
      exerciseId: map['exerciseId'] as int,
      muscleId: map['muscleId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondaryMusclesRowAPI.fromJson(String source) =>
      SecondaryMusclesRowAPI.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SecondaryMusclesRowAPI(exerciseId: $exerciseId, muscleId: $muscleId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant SecondaryMusclesRowAPI other) {
    if (identical(this, other)) return true;

    return other.exerciseId == exerciseId &&
        other.muscleId == muscleId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return exerciseId.hashCode ^
        muscleId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
