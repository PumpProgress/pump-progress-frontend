// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class SecondaryMuscleRow extends DBRow {
  final int exerciseId;
  final int muscleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  @override
  String get tableName => tableNameStatic;
  static const String tableNameStatic = 'exercise_secondary_muscles';

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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'exerciseId': exerciseId,
      'muscleId': muscleId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  @override
  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'exercise_id': exerciseId,
      'muscle_id': muscleId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory SecondaryMuscleRow.fromDB(Map<String, dynamic> map) {
    return SecondaryMuscleRow(
      exerciseId: map['exercise_id'] as int,
      muscleId: map['muscle_id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
    );
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

  @override
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
