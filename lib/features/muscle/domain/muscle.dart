// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Muscle {
  final int id;
  final String name;
  final String code;
  Muscle({
    required this.id,
    required this.name,
    required this.code,
  });

  Muscle copyWith({
    int? id,
    String? name,
    String? code,
  }) {
    return Muscle(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
    };
  }

  factory Muscle.fromMap(Map<String, dynamic> map) {
    return Muscle(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Muscle.fromJson(String source) =>
      Muscle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Muscle(id: $id, name: $name, code: $code)';

  @override
  bool operator ==(covariant Muscle other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.code == code;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ code.hashCode;
}
