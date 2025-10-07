// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SecondaryMuscleRow {
  final int exerciseId;
  final int muscleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  SecondaryMuscleRow({
    required this.exerciseId,
    required this.muscleId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  SecondaryMuscleRow copyWith({
    int? exerciseId,
    int? muscleId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return SecondaryMuscleRow(
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

  factory SecondaryMuscleRow.fromMap(Map<String, dynamic> map) {
    return SecondaryMuscleRow(
      exerciseId: map['exerciseId'] as int,
      muscleId: map['muscleId'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondaryMuscleRow.fromJson(String source) =>
      SecondaryMuscleRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SecondaryMuscleRow(exerciseId: $exerciseId, muscleId: $muscleId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant SecondaryMuscleRow other) {
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
