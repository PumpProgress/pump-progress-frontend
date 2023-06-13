import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<String> favoriteExercises;

  static const unknown =
      User(id: '', name: '', email: '', favoriteExercises: []);

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteExercises,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? favoriteExercises,
  }) {
    return User(
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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      favoriteExercises:
          List<String>.from(map['favoriteExercises'] as Iterable<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, favoriteExercises: $favoriteExercises)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
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
