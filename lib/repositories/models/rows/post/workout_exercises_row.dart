import 'dart:convert';

import 'package:pump_progress_frontend/data/sqlite/db_row.dart';

class WorkoutExercisesRow implements DbRowWrite {
  final String id;
  final String userId;
  final String workoutId;
  final int exerciseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int isDirty;

  @override
  String get tableName => tableNameStatic;
  static const String tableNameStatic = 'workout_exercises';

  WorkoutExercisesRow({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.exerciseId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDirty = 0,
  });

  WorkoutExercisesRow copyWith({
    String? id,
    String? userId,
    String? workoutId,
    int? exerciseId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? isDirty,
  }) {
    return WorkoutExercisesRow(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'deletedAt': deletedAt?.toUtc().toIso8601String(),
      'isDirty': isDirty,
    };
  }

  factory WorkoutExercisesRow.fromMap(Map<String, dynamic> map) {
    return WorkoutExercisesRow(
      id: map['id'] as String,
      userId: map['userId'] as String,
      workoutId: map['workoutId'] as String,
      exerciseId: map['exerciseId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
    );
  }

  factory WorkoutExercisesRow.fromDB(Map<String, dynamic> map) {
    return WorkoutExercisesRow(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      workoutId: map['workout_id'] as String,
      exerciseId: map['exercise_id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
      isDirty: map['is_dirty'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      'is_dirty': isDirty,
    };
  }

  String toJson() => json.encode(toMap());

  factory WorkoutExercisesRow.fromJson(String source) =>
      WorkoutExercisesRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutExercisesRow(id: $id, userId: $userId, workoutId: $workoutId, exerciseId: $exerciseId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, isDirty: $isDirty)';
  }

  @override
  bool operator ==(covariant WorkoutExercisesRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.workoutId == workoutId &&
        other.exerciseId == exerciseId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.isDirty == isDirty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        workoutId.hashCode ^
        exerciseId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        isDirty.hashCode;
  }
}
