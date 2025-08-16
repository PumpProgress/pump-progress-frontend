// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExerciseAnalyticsAPI {
  final String date;
  final double sessionVolume;
  final int totalSets;
  final int totalReps;
  final double avgWeightPerRep;
  final double maxWeight;
  final double minWeight;

  ExerciseAnalyticsAPI({
    required this.date,
    required this.sessionVolume,
    required this.totalSets,
    required this.totalReps,
    required this.avgWeightPerRep,
    required this.maxWeight,
    required this.minWeight,
  });

  ExerciseAnalyticsAPI copyWith({
    String? date,
    double? sessionVolume,
    int? totalSets,
    int? totalReps,
    double? avgWeightPerRep,
    double? maxWeight,
    double? minWeight,
  }) {
    return ExerciseAnalyticsAPI(
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

  factory ExerciseAnalyticsAPI.fromMap(Map<String, dynamic> map) {
    return ExerciseAnalyticsAPI(
      date: map['date'] as String,
      sessionVolume: double.parse(map['sessionVolume'].toString()),
      totalSets: map['totalSets'] as int,
      totalReps: map['totalReps'] as int,
      avgWeightPerRep: double.parse(map['avgWeightPerRep'].toString()),
      maxWeight: double.parse(map['maxWeight'].toString()),
      minWeight: double.parse(map['minWeight'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAnalyticsAPI.fromJson(String source) =>
      ExerciseAnalyticsAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseAnalyticsAPI(date: $date, sessionVolume: $sessionVolume, totalSets: $totalSets, totalReps: $totalReps, avgWeightPerRep: $avgWeightPerRep, maxWeight: $maxWeight, minWeight: $minWeight)';
  }

  @override
  bool operator ==(covariant ExerciseAnalyticsAPI other) {
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
