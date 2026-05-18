// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class SetsRow extends DbRowWrite {
  @override
  final String id;
  final String userId;
  final int exerciseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int repetitions;
  final double weight;
  final int intensity;
  final int isDirty;

  @override
  String get tableName => tableNameStatic;
  static const String tableNameStatic = 'sets';

  SetsRow({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.repetitions,
    required this.weight,
    required this.intensity,
    this.isDirty = 0,
  });

  SetsRow copyWith({
    String? id,
    String? userId,
    int? exerciseId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? repetitions,
    double? weight,
    int? intensity,
    int? isDirty,
  }) {
    return SetsRow(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      intensity: intensity ?? this.intensity,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'deletedAt': deletedAt?.toUtc().toIso8601String(),
      'repetitions': repetitions,
      'weight': weight,
      'intensity': intensity,
      'isDirty': isDirty,
    };
  }

  factory SetsRow.fromMap(Map<String, dynamic> map) {
    return SetsRow(
      id: map['id'] as String,
      userId: map['userId'] as String,
      exerciseId: map['exerciseId'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
      intensity: map['intensity'] as int,
      isDirty: map['isDirty'] as int? ?? 0,
    );
  }

  factory SetsRow.fromDB(Map<String, dynamic> map) {
    return SetsRow(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      exerciseId: map['exercise_id'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
      intensity: map['intensity'] as int,
      isDirty: map['is_dirty'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      'repetitions': repetitions,
      'weight': weight,
      'intensity': intensity,
      'is_dirty': isDirty,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  factory SetsRow.fromJson(String source) =>
      SetsRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SetsRow(id: $id, userId: $userId, exerciseId: $exerciseId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, repetitions: $repetitions, weight: $weight, intensity: $intensity, isDirty: $isDirty)';
  }

  @override
  bool operator ==(covariant SetsRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.exerciseId == exerciseId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.repetitions == repetitions &&
        other.weight == weight &&
        other.intensity == intensity &&
        other.isDirty == isDirty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        exerciseId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        repetitions.hashCode ^
        weight.hashCode ^
        intensity.hashCode ^
        isDirty.hashCode;
  }
}
