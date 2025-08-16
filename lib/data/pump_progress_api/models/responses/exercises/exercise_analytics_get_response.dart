// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/exercises/exercise_analytics.dart';

class ExerciseAnalyticsGetResponse {
  final List<ExerciseAnalyticsAPI> dailyStats;
  // final Object dateRange;
  final String timezone;
  ExerciseAnalyticsGetResponse({
    required this.dailyStats,
    required this.timezone,
  });

  ExerciseAnalyticsGetResponse copyWith({
    List<ExerciseAnalyticsAPI>? dailyStats,
    String? timezone,
  }) {
    return ExerciseAnalyticsGetResponse(
      dailyStats: dailyStats ?? this.dailyStats,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyStats': dailyStats.map((x) => x.toMap()).toList(),
      'timezone': timezone,
    };
  }

  factory ExerciseAnalyticsGetResponse.fromMap(Map<String, dynamic> map) {
    return ExerciseAnalyticsGetResponse(
      dailyStats: List<ExerciseAnalyticsAPI>.from(
        (map['dailyStats'] as List).map<ExerciseAnalyticsAPI>(
          (x) => ExerciseAnalyticsAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseAnalyticsGetResponse.fromJson(String source) =>
      ExerciseAnalyticsGetResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ExerciseAnalyticsGetResponse(dailyStats: $dailyStats, timezone: $timezone)';

  @override
  bool operator ==(covariant ExerciseAnalyticsGetResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.dailyStats, dailyStats) &&
        other.timezone == timezone;
  }

  @override
  int get hashCode => dailyStats.hashCode ^ timezone.hashCode;
}
