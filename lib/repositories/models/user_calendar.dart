// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserCalendar {
  final Map<String, List<String>> dates;
  const UserCalendar({
    required this.dates,
  });

  UserCalendar copyWith({
    Map<String, List<String>>? dates,
  }) {
    return UserCalendar(
      dates: dates ?? this.dates,
    );
  }

  static const UserCalendar empty = UserCalendar(dates: {});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dates': dates,
    };
  }

  factory UserCalendar.fromMap(Map<String, dynamic> map) {
    return UserCalendar(
        dates: (map['dates'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List))));
  }

  String toJson() => json.encode(toMap());

  factory UserCalendar.fromJson(String source) =>
      UserCalendar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserCalendar(dates: $dates)';

  @override
  bool operator ==(covariant UserCalendar other) {
    if (identical(this, other)) return true;

    return mapEquals(other.dates, dates);
  }

  @override
  int get hashCode => dates.hashCode;
}
