import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MeSet {
  const MeSet({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
    required this.createdAt,
  });

  factory MeSet.fromJson(String source) =>
      MeSet.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MeSet.fromMap(Map<String, dynamic> map) {
    return MeSet(
      id: map['id'].toString(),
      userId: map['userId'].toString(),
      exerciseId: map['exerciseId'].toString(),
      repetitions: int.parse(map['repetitions'].toString()),
      weight: double.parse(map['weight'].toString()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
  final String id;
  final String userId;
  final String exerciseId;
  final int repetitions;
  final double weight;
  final DateTime createdAt;

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

  String toJson() => json.encode(toMap());

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
