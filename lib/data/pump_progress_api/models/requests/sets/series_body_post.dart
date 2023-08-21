import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class SeriesBodyPost {
  final String exerciseId;
  final int repetitions;
  final double weight;
  const SeriesBodyPost({
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
  });

  SeriesBodyPost copyWith({
    String? exerciseId,
    int? repetitions,
    double? weight,
  }) {
    return SeriesBodyPost(
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

  factory SeriesBodyPost.fromMap(Map<String, dynamic> map) {
    return SeriesBodyPost(
      exerciseId: map['exerciseId'] as String,
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeriesBodyPost.fromJson(String source) =>
      SeriesBodyPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SeriesBodyPost(exerciseId: $exerciseId, repetitions: $repetitions, weight: $weight)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SeriesBodyPost &&
        other.exerciseId == exerciseId &&
        other.repetitions == repetitions &&
        other.weight == weight;
  }

  @override
  int get hashCode =>
      exerciseId.hashCode ^ repetitions.hashCode ^ weight.hashCode;
}
