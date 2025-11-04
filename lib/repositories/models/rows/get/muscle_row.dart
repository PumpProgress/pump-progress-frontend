// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/data/sqlite/db_row.dart';

class MuscleRow implements DBRow {
  final int id;
  final String name;
  final String code;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;

  @override
  String get tableName => tableNameStatic;
  static const String tableNameStatic = 'muscles';

  @override
  MuscleRow({
    required this.id,
    required this.name,
    required this.code,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
  });

  MuscleRow copyWith({
    int? id,
    String? name,
    String? code,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return MuscleRow(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory MuscleRow.fromMap(Map<String, dynamic> map) {
    return MuscleRow(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory MuscleRow.fromJson(String source) =>
      MuscleRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory MuscleRow.fromDB(Map<String, dynamic> map) {
    return MuscleRow(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
    );
  }

  @override
  String toString() {
    return 'MuscleRow(id: $id, name: $name, code: $code, updatedAt: $updatedAt, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant MuscleRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode;
  }
}
