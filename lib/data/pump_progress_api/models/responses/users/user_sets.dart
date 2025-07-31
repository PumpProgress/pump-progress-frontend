// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/users/user_series_calendar.dart';

class UserSetsAPI {
  final List<SeriesCalendarAPI> sets;
  UserSetsAPI({
    required this.sets,
  });

  UserSetsAPI copyWith({
    List<SeriesCalendarAPI>? sets,
  }) {
    return UserSetsAPI(
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sets': sets.map((x) => x.toMap()).toList(),
    };
  }

  factory UserSetsAPI.fromMap(Map<String, dynamic> map) {
    return UserSetsAPI(
      sets: List<SeriesCalendarAPI>.from(
        (map['sets'] as List<dynamic>).map<SeriesCalendarAPI>(
          (x) => SeriesCalendarAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSetsAPI.fromJson(String source) =>
      UserSetsAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserSetsAPI(sets: $sets)';

  @override
  bool operator ==(covariant UserSetsAPI other) {
    if (identical(this, other)) return true;

    return listEquals(other.sets, sets);
  }

  @override
  int get hashCode => sets.hashCode;
}
