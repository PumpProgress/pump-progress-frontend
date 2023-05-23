import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

part 'exercise.g.dart';

@immutable
@HiveType(typeId: 0)
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscles,
    this.isFavorite = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final List<String> muscles;

  @HiveField(4)
  final bool isFavorite;

  Exercise copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? muscles,
    bool? isFavorite,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      muscles: muscles ?? this.muscles,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'muscles': muscles,
      'isFavorite': isFavorite,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      muscles: List<String>.from(map['muscles'] as Iterable<dynamic>),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, category: $category, muscles: $muscles, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        listEquals(other.muscles, muscles) &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        muscles.hashCode ^
        isFavorite.hashCode;
  }
}
