import 'dart:convert';

import 'package:flutter/foundation.dart';

@Deprecated('Use Exercise from features instead')
@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscles,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final String category;
  final List<String> muscles;
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
