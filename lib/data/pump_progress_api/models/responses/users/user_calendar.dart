// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserCalendarAPI {
  final Map<String, List<String>> dates;
  UserCalendarAPI({
    required this.dates,
  });

  UserCalendarAPI copyWith({
    Map<String, List<String>>? dates,
  }) {
    return UserCalendarAPI(
      dates: dates ?? this.dates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dates': dates,
    };
  }

  factory UserCalendarAPI.fromMap(Map<String, dynamic> map) {
    return UserCalendarAPI(
        dates: (map['dates'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List))));
  }

  String toJson() => json.encode(toMap());

  factory UserCalendarAPI.fromJson(String source) =>
      UserCalendarAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserCalendarAPI(dates: $dates)';

  @override
  bool operator ==(covariant UserCalendarAPI other) {
    if (identical(this, other)) return true;

    return mapEquals(other.dates, dates);
  }

  @override
  int get hashCode => dates.hashCode;
}
