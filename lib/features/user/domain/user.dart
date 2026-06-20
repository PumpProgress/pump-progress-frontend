import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<String> favoriteExercises;
  final int? age;
  final String? gender;
  final String? fitnessLevel;
  final String? primaryGoal;
  final int? trainingDaysPerWeek;

  static const unknown =
      User(id: '', name: '', email: '', favoriteExercises: []);

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteExercises,
    this.age,
    this.gender,
    this.fitnessLevel,
    this.primaryGoal,
    this.trainingDaysPerWeek,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? favoriteExercises,
    int? age,
    String? gender,
    String? fitnessLevel,
    String? primaryGoal,
    int? trainingDaysPerWeek,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      favoriteExercises: favoriteExercises ?? this.favoriteExercises,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      trainingDaysPerWeek: trainingDaysPerWeek ?? this.trainingDaysPerWeek,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favoriteExercises': favoriteExercises,
      'age': age,
      'gender': gender,
      'fitnessLevel': fitnessLevel,
      'primaryGoal': primaryGoal,
      'trainingDaysPerWeek': trainingDaysPerWeek,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      favoriteExercises:
          List<String>.from(map['favoriteExercises'] as Iterable<dynamic>),
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      fitnessLevel: map['fitnessLevel'] as String?,
      primaryGoal: map['primaryGoal'] as String?,
      trainingDaysPerWeek: map['trainingDaysPerWeek'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, '
        'favoriteExercises: $favoriteExercises, age: $age, gender: $gender, '
        'fitnessLevel: $fitnessLevel, primaryGoal: $primaryGoal, '
        'trainingDaysPerWeek: $trainingDaysPerWeek)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.favoriteExercises, favoriteExercises) &&
        other.age == age &&
        other.gender == gender &&
        other.fitnessLevel == fitnessLevel &&
        other.primaryGoal == primaryGoal &&
        other.trainingDaysPerWeek == trainingDaysPerWeek;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        favoriteExercises.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        fitnessLevel.hashCode ^
        primaryGoal.hashCode ^
        trainingDaysPerWeek.hashCode;
  }
}
