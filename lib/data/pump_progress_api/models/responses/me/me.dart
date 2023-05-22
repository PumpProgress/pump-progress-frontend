import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Me {
  const Me({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteExercises,
  });

  factory Me.fromJson(String source) =>
      Me.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Me.fromMap(Map<String, dynamic> map) {
    return Me(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      favoriteExercises:
          List<String>.from(map['favoriteExercises'] as Iterable<dynamic>),
    );
  }
  final String id;
  final String name;
  final String email;
  final List<String> favoriteExercises;

  Me copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? favoriteExercises,
  }) {
    return Me(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      favoriteExercises: favoriteExercises ?? this.favoriteExercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favoriteExercises': favoriteExercises,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Me(id: $id, name: $name, email: $email, favoriteExercises: $favoriteExercises)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Me &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.favoriteExercises, favoriteExercises);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        favoriteExercises.hashCode;
  }
}
