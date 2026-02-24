import 'dart:convert';

import 'package:flutter/foundation.dart';

class CalendarSeries {
  final Map<String, dynamic> dates;
  const CalendarSeries({
    required this.dates,
  });

  CalendarSeries copyWith({
    Map<String, List<String>>? dates,
  }) {
    return CalendarSeries(
      dates: dates ?? this.dates,
    );
  }

  static const CalendarSeries empty = CalendarSeries(dates: {});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dates': dates,
    };
  }

  factory CalendarSeries.fromMap(Map<String, dynamic> map) {
    return CalendarSeries(
        dates: (map['dates'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List))));
  }

  String toJson() => json.encode(toMap());

  factory CalendarSeries.fromJson(String source) =>
      CalendarSeries.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CalendarSeries(dates: $dates)';

  @override
  bool operator ==(covariant CalendarSeries other) {
    if (identical(this, other)) return true;

    return mapEquals(other.dates, dates);
  }

  @override
  int get hashCode => dates.hashCode;
}
