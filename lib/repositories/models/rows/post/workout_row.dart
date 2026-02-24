// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/data/sqlite/db_row.dart';

class WorkoutRow implements DbRowWrite {
  final String id;
  final String userId;
  final String name;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final int isDirty;

  @override
  String get tableName => tableNameStatic;
  static const String tableNameStatic = 'workouts';

  WorkoutRow({
    required this.id,
    required this.userId,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    this.isDirty = 0,
  });

  WorkoutRow copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? isDirty,
  }) {
    return WorkoutRow(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'deletedAt': deletedAt?.toUtc().toIso8601String(),
      'isDirty': isDirty,
    };
  }

  factory WorkoutRow.fromMap(Map<String, dynamic> map) {
    return WorkoutRow(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
      isDirty: map['isDirty'] as int? ?? 0,
    );
  }
  factory WorkoutRow.fromDB(Map<String, dynamic> map) {
    return WorkoutRow(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
      isDirty: map['is_dirty'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toDB() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      'is_dirty': isDirty,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  factory WorkoutRow.fromJson(String source) =>
      WorkoutRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutRow(id: $id, userId: $userId, name: $name, updatedAt: $updatedAt, createdAt: $createdAt, deletedAt: $deletedAt, isDirty: $isDirty)';
  }

  @override
  bool operator ==(covariant WorkoutRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt &&
        other.isDirty == isDirty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode ^
        isDirty.hashCode;
  }
}
