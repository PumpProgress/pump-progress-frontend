// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/sqlite/db_row.dart';

class PostSync<T extends DBRow> {
  final List<T> updates;
  final DateTime time;
  PostSync({
    required this.updates,
    required this.time,
  });

  PostSync<T> copyWith({
    List<T>? updates,
    DateTime? time,
  }) {
    return PostSync<T>(
      updates: updates ?? this.updates,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'updates': updates.map((x) => x.toMap()).toList(),
      'time': time.toUtc().toIso8601String(),
    };
  }

  factory PostSync.fromMap(Map<String, dynamic> map) {
    return PostSync<T>(
      updates: List<T>.from(
        (map['updates'] as List<dynamic>).map<T>(
          (x) => DBRowFactory.fromMap(x as Map<String, dynamic>),
        ),
      ),
      time: DateTime.parse(map['time'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostSync.fromJson(String source) =>
      PostSync.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostSync(updates: $updates, time: $time)';

  @override
  bool operator ==(covariant PostSync<T> other) {
    if (identical(this, other)) return true;

    return listEquals(other.updates, updates) && other.time == time;
  }

  @override
  int get hashCode => updates.hashCode ^ time.hashCode;
}
