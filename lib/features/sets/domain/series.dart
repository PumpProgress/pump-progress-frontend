import 'dart:convert';

class Series {
  Series({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.repetitions,
    required this.weight,
    required this.createdAt,
  });
  factory Series.fromJson(String source) =>
      Series.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Series.fromMap(Map<String, dynamic> map) {
    return Series(
      id: map['id'] as String,
      userId: map['userId'] as String,
      exerciseId: map['exerciseId'] as int,
      repetitions: map['repetitions'] as int,
      weight: map['weight'] as double,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
  final String id;
  final String userId;
  final int exerciseId;
  final int repetitions;
  final double weight;
  final DateTime createdAt;

  Series copyWith({
    String? id,
    String? userId,
    int? exerciseId,
    int? repetitions,
    double? weight,
    DateTime? createdAt,
  }) {
    return Series(
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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Series(id: $id, userId: $userId, exerciseId: $exerciseId, repetitions: $repetitions, weight: $weight, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Series &&
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
