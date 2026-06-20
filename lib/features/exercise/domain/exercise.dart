import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscles,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String category;
  final List<String> muscles;
  final bool isFavorite;

  const Exercise.empty({
    this.id = 0,
    this.name = '',
    this.category = '',
    this.muscles = const <String>[],
    this.isFavorite = false,
  });

  Exercise copyWith({
    int? id,
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
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      muscles: map['muscles'] != null
          ? List<String>.from(map['muscles'] as Iterable<dynamic>)
          : const [],
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
