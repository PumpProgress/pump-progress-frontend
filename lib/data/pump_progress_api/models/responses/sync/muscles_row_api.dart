// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MuscleRowAPI {
  final int id;
  final String name;
  final String code;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? deletedAt;

  MuscleRowAPI({
    required this.id,
    required this.name,
    required this.code,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
  });

  MuscleRowAPI copyWith({
    int? id,
    String? name,
    String? code,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return MuscleRowAPI(
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

  factory MuscleRowAPI.fromMap(Map<String, dynamic> map) {
    return MuscleRowAPI(
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

  String toJson() => json.encode(toMap());

  factory MuscleRowAPI.fromJson(String source) =>
      MuscleRowAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MuscleRowAPI(id: $id, name: $name, code: $code, updatedAt: $updatedAt, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant MuscleRowAPI other) {
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
