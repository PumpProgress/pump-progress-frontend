import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MeSet {
  final String id;
  final String userId;
  final String exerciseId;
  final int repetitions;
  final double weight;
  final DateTime createdAt;
  MeSet({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
    required this.createdAt,
  });

  MeSet copyWith({
    String? id,
    String? userId,
    String? exerciseId,
    int? repetitions,
    double? weight,
    DateTime? createdAt,
  }) {
    return MeSet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weight': weight,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory MeSet.fromMap(Map<String, dynamic> map) {
    return MeSet(
      id: map['id'] as String,
      userId: map['userId'] as String,
      exerciseId: map['exerciseId'] as String,
      repetitions: (map['repetitions']) as int,
      weight: map['weight'] as double,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeSet.fromJson(String source) =>
      MeSet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MeSet(id: $id, userId: $userId, exerciseId: $exerciseId, repetitions: $repetitions, weight: $weight, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeSet &&
        other.id == id &&
        other.userId == userId &&
        other.exerciseId == exerciseId &&
        other.repetitions == repetitions &&
        other.weight == weight &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        exerciseId.hashCode ^
        repetitions.hashCode ^
        weight.hashCode ^
        createdAt.hashCode;
  }
}
