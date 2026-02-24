import 'dart:convert';

import 'package:pump_progress_frontend/utils/helpers/sql_database_helper/db_rows.dart';

class ExerciseRow implements DBRow {
  final int id;
  final String code;
  final String name;
  final int? primaryMuscleId;
  final String? force;
  final String? level;
  final String? mechanic;
  final int? equipmentId;
  final int? categoryId;
  final List<String>? instructions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  static const String tableNameStatic = 'exercises';

  @override
  String get tableName => tableNameStatic;

  ExerciseRow({
    required this.id,
    required this.code,
    required this.name,
    this.primaryMuscleId,
    this.force,
    this.level,
    this.mechanic,
    this.equipmentId,
    this.categoryId,
    this.instructions,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  ExerciseRow copyWith({
    int? id,
    String? code,
    String? name,
    int? primaryMuscleId,
    String? force,
    String? level,
    String? mechanic,
    int? equipmentId,
    int? categoryId,
    List<String>? instructions,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ExerciseRow(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      primaryMuscleId: primaryMuscleId ?? this.primaryMuscleId,
      force: force ?? this.force,
      level: level ?? this.level,
      mechanic: mechanic ?? this.mechanic,
      equipmentId: equipmentId ?? this.equipmentId,
      categoryId: categoryId ?? this.categoryId,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'primaryMuscleId': primaryMuscleId,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipmentId': equipmentId,
      'categoryId': categoryId,
      'instructions': instructions,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'deletedAt': deletedAt?.toUtc().toIso8601String(),
    };
  }

  factory ExerciseRow.fromMap(Map<String, dynamic> map) {
    return ExerciseRow(
      id: map['id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      primaryMuscleId:
          map['primaryMuscleId'] != null ? map['primaryMuscleId'] as int : null,
      force: map['force'] != null ? map['force'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      mechanic: map['mechanic'] != null ? map['mechanic'] as String : null,
      equipmentId:
          map['equipmentId'] != null ? map['equipmentId'] as int : null,
      categoryId: map['categoryId'] != null ? map['categoryId'] as int : null,
      instructions: map['instructions'] != null
          ? List<String>.from(map['instructions'] as List)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toDB() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'primary_muscle_id': primaryMuscleId,
      'force': force,
      'level': level,
      'mechanic': mechanic,
      'equipment_id': equipmentId,
      'category_id': categoryId,
      'instructions': jsonEncode(instructions),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  @override
  factory ExerciseRow.fromDB(Map<String, dynamic> map) {
    return ExerciseRow(
      id: map['id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      primaryMuscleId: map['primary_muscle_id'] as int?,
      force: map['force'] as String?,
      level: map['level'] as String?,
      mechanic: map['mechanic'] as String?,
      equipmentId: map['equipment_id'] as int?,
      categoryId: map['category_id'] as int?,
      instructions: (map['instructions'] as String?) != null
          ? List<String>.from(jsonDecode(map['instructions']))
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseRow.fromJson(String source) =>
      ExerciseRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseRow(id: $id, code: $code, name: $name, primaryMuscleId: $primaryMuscleId, force: $force, level: $level, mechanic: $mechanic, equipmentId: $equipmentId, categoryId: $categoryId, instructions: $instructions, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant ExerciseRow other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.primaryMuscleId == primaryMuscleId &&
        other.force == force &&
        other.level == level &&
        other.mechanic == mechanic &&
        other.equipmentId == equipmentId &&
        other.categoryId == categoryId &&
        other.instructions == instructions &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        primaryMuscleId.hashCode ^
        force.hashCode ^
        level.hashCode ^
        mechanic.hashCode ^
        equipmentId.hashCode ^
        categoryId.hashCode ^
        instructions.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
