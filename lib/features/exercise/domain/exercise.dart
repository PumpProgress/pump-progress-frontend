import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.muscles,
    this.equipment,
    this.force,
    this.mechanic,
    this.level,
    this.aliases = const <String>[],
    this.isFavorite = false,
  });

  final int id;
  final String code;
  final String name;
  final String category;
  final List<String> muscles;
  final String? equipment;
  final String? force;
  final String? mechanic;
  final String? level;
  final List<String> aliases;
  final bool isFavorite;

  /// Pre-tokenized, noise-free search terms derived from the machine code.
  /// "barbell_bench_press" -> ["barbell", "bench", "press"]
  List<String> get codeTokens => code.split('_');

  const Exercise.empty({
    this.id = 0,
    this.code = '',
    this.name = '',
    this.category = '',
    this.muscles = const <String>[],
    this.equipment,
    this.force,
    this.mechanic,
    this.level,
    this.aliases = const <String>[],
    this.isFavorite = false,
  });

  Exercise copyWith({
    int? id,
    String? code,
    String? name,
    String? category,
    List<String>? muscles,
    String? equipment,
    String? force,
    String? mechanic,
    String? level,
    List<String>? aliases,
    bool? isFavorite,
  }) {
    return Exercise(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      muscles: muscles ?? this.muscles,
      equipment: equipment ?? this.equipment,
      force: force ?? this.force,
      mechanic: mechanic ?? this.mechanic,
      level: level ?? this.level,
      aliases: aliases ?? this.aliases,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'category': category,
      'muscles': muscles,
      'equipment': equipment,
      'force': force,
      'mechanic': mechanic,
      'level': level,
      'aliases': aliases,
      'isFavorite': isFavorite,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int? ?? 0,
      code: map['code'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      muscles: map['muscles'] != null
          ? List<String>.from(map['muscles'] as Iterable<dynamic>)
          : const [],
      equipment: map['equipment'] as String?,
      force: map['force'] as String?,
      mechanic: map['mechanic'] as String?,
      level: map['level'] as String?,
      aliases: map['aliases'] != null
          ? List<String>.from(map['aliases'] as Iterable<dynamic>)
          : const [],
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Exercise(id: $id, code: $code, name: $name, category: $category, '
        'muscles: $muscles, equipment: $equipment, force: $force, '
        'mechanic: $mechanic, level: $level, aliases: $aliases, '
        'isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Exercise &&
        other.id == id &&
        other.code == code &&
        other.name == name &&
        other.category == category &&
        listEquals(other.muscles, muscles) &&
        other.equipment == equipment &&
        other.force == force &&
        other.mechanic == mechanic &&
        other.level == level &&
        listEquals(other.aliases, aliases) &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        category.hashCode ^
        Object.hashAll(muscles) ^
        equipment.hashCode ^
        force.hashCode ^
        mechanic.hashCode ^
        level.hashCode ^
        Object.hashAll(aliases) ^
        isFavorite.hashCode;
  }
}
