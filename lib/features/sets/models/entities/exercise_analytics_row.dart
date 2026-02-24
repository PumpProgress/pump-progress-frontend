// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExerciseAnalyticsRow {
  final String date;
  final double sessionVolume;
  final int totalSets;
  final int totalReps;
  final double avgWeightPerRep;
  final double maxWeight;
  final double minWeight;

  const ExerciseAnalyticsRow({
    required this.date,
    required this.sessionVolume,
    required this.totalSets,
    required this.totalReps,
    required this.avgWeightPerRep,
    required this.maxWeight,
    required this.minWeight,
  });

  factory ExerciseAnalyticsRow.fromDB(Map<String, dynamic> map) {
    return ExerciseAnalyticsRow(
      date: map['date'] as String,
      sessionVolume: (map['sessionVolume'] as num).toDouble(),
      totalSets: (map['totalSets'] as num).toInt(),
      totalReps: (map['totalReps'] as num).toInt(),
      avgWeightPerRep: (map['avgWeightPerRep'] as num).toDouble(),
      maxWeight: (map['maxWeight'] as num).toDouble(),
      minWeight: (map['minWeight'] as num).toDouble(),
    );
  }

  ExerciseAnalyticsRow copyWith({
    String? date,
    double? sessionVolume,
    int? totalSets,
    int? totalReps,
    double? avgWeightPerRep,
    double? maxWeight,
    double? minWeight,
  }) {
    return ExerciseAnalyticsRow(
      date: date ?? this.date,
      sessionVolume: sessionVolume ?? this.sessionVolume,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      avgWeightPerRep: avgWeightPerRep ?? this.avgWeightPerRep,
      maxWeight: maxWeight ?? this.maxWeight,
      minWeight: minWeight ?? this.minWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'sessionVolume': sessionVolume,
      'totalSets': totalSets,
      'totalReps': totalReps,
      'avgWeightPerRep': avgWeightPerRep,
      'maxWeight': maxWeight,
      'minWeight': minWeight,
    };
  }

  factory ExerciseAnalyticsRow.fromMap(Map<String, dynamic> map) {
    return ExerciseAnalyticsRow(
      date: map['date'] as String,
      sessionVolume: map['sessionVolume'] as double,
      totalSets: map['totalSets'] as int,
      totalReps: map['totalReps'] as int,
      avgWeightPerRep: map['avgWeightPerRep'] as double,
      maxWeight: map['maxWeight'] as double,
      minWeight: map['minWeight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAnalyticsRow.fromJson(String source) =>
      ExerciseAnalyticsRow.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseAnalyticsRow(date: $date, sessionVolume: $sessionVolume, totalSets: $totalSets, totalReps: $totalReps, avgWeightPerRep: $avgWeightPerRep, maxWeight: $maxWeight, minWeight: $minWeight)';
  }

  @override
  bool operator ==(covariant ExerciseAnalyticsRow other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.sessionVolume == sessionVolume &&
        other.totalSets == totalSets &&
        other.totalReps == totalReps &&
        other.avgWeightPerRep == avgWeightPerRep &&
        other.maxWeight == maxWeight &&
        other.minWeight == minWeight;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        sessionVolume.hashCode ^
        totalSets.hashCode ^
        totalReps.hashCode ^
        avgWeightPerRep.hashCode ^
        maxWeight.hashCode ^
        minWeight.hashCode;
  }
}
