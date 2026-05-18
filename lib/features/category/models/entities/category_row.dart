// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class CategoryRow implements DBRow {
  final int id;
  final String name;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;

  @override
  String get tableName => tableNameStatic;

  static const String tableNameStatic = 'category_types';

  CategoryRow({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
  });

  CategoryRow copyWith({
    int? id,
    String? name,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return CategoryRow(
      id: id ?? this.id,
      name: name ?? this.name,
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
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory CategoryRow.fromMap(Map<String, dynamic> map) {
    return CategoryRow(
      id: map['id'] as int,
      name: map['name'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory CategoryRow.fromDB(Map<String, dynamic> map) {
    return CategoryRow(
      id: map['id'] as int,
      name: map['name'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CategoryRow.fromJson(String source) =>
      CategoryRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryRow(id: $id, name: $name, updatedAt: $updatedAt, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant CategoryRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode;
  }
}
