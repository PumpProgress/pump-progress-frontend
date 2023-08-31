import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class SeriesBodyPut {
  final int repetitions;
  final double weight;
  const SeriesBodyPut({
    required this.repetitions,
    required this.weight,
  });

  SeriesBodyPut copyWith({
    int? repetitions,
    double? weight,
  }) {
    return SeriesBodyPut(
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'repetitions': repetitions,
      'weight': weight,
    };
  }

  factory SeriesBodyPut.fromMap(Map<String, dynamic> map) {
    return SeriesBodyPut(
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeriesBodyPut.fromJson(String source) =>
      SeriesBodyPut.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SeriesBodyPut(repetitions: $repetitions, weight: $weight)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SeriesBodyPut &&
        other.repetitions == repetitions &&
        other.weight == weight;
  }

  @override
  int get hashCode => repetitions.hashCode ^ weight.hashCode;
}
