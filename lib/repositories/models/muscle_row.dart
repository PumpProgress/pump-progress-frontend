// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MuscleRow {
  final int id;
  final String name;
  final String code;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;
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

  factory MuscleRow.fromMap(Map<String, dynamic> map) {
    return MuscleRow(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MuscleRow.fromJson(String source) =>
      MuscleRow.fromMap(json.decode(source) as Map<String, dynamic>);

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
