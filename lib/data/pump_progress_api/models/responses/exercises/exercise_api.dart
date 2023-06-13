import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class ExerciseAPI {
  const ExerciseAPI({
    required this.id,
    required this.name,
    required this.category,
    required this.muscles,
  });

  final String id;
  final String name;
  final String category;
  final List<String> muscles;

  ExerciseAPI copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? muscles,
  }) {
    return ExerciseAPI(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      muscles: muscles ?? this.muscles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'muscles': muscles,
    };
  }

  factory ExerciseAPI.fromMap(Map<String, dynamic> map) {
    return ExerciseAPI(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      muscles: List<String>.from(
        (map['muscles'] ?? <String>[]) as Iterable<dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAPI.fromJson(String source) =>
      ExerciseAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseAPI(id: $id, name: $name, category: $category, muscles: $muscles)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExerciseAPI &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        listEquals(other.muscles, muscles);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ category.hashCode ^ muscles.hashCode;
  }
}
