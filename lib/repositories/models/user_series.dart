// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSeries {
  final String name;
  final String exerciseId;
  UserSeries({
    required this.name,
    required this.exerciseId,
  });

  UserSeries copyWith({
    String? name,
    String? exerciseId,
  }) {
    return UserSeries(
      name: name ?? this.name,
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'exerciseId': exerciseId,
    };
  }

  factory UserSeries.fromMap(Map<String, dynamic> map) {
    return UserSeries(
      name: map['name'] as String,
      exerciseId: map['exerciseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSeries.fromJson(String source) =>
      UserSeries.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserSeries(name: $name, exerciseId: $exerciseId)';

  @override
  bool operator ==(covariant UserSeries other) {
    if (identical(this, other)) return true;

    return other.name == name && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => name.hashCode ^ exerciseId.hashCode;
}
