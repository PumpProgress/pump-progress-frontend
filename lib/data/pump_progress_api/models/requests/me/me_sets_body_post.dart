import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MeSetBodyPost {
  final String exerciseId;
  final int repetitions;
  final double weight;
  const MeSetBodyPost({
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
  });

  MeSetBodyPost copyWith({
    String? exerciseId,
    int? repetitions,
    double? weight,
  }) {
    return MeSetBodyPost(
      exerciseId: exerciseId ?? this.exerciseId,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'repetitions': repetitions,
      'weight': weight,
    };
  }

  factory MeSetBodyPost.fromMap(Map<String, dynamic> map) {
    return MeSetBodyPost(
      exerciseId: map['exerciseId'] as String,
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MeSetBodyPost.fromJson(String source) =>
      MeSetBodyPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MeSetBodyPost(exerciseId: $exerciseId, repetitions: $repetitions, weight: $weight)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeSetBodyPost &&
        other.exerciseId == exerciseId &&
        other.repetitions == repetitions &&
        other.weight == weight;
  }

  @override
  int get hashCode =>
      exerciseId.hashCode ^ repetitions.hashCode ^ weight.hashCode;
}
