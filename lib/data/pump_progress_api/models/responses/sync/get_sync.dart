// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/data/sqlite/db_row.dart';

class GetSync<T extends DBRow> {
  final List<T> data;
  GetSync({
    required this.data,
  });

  GetSync<T> copyWith({
    List<T>? data,
  }) {
    return GetSync<T>(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory GetSync.fromMap(Map<String, dynamic> map) {
    return GetSync<T>(
      data: List<T>.from(
        (map['data'] as List<dynamic>).map<T>(
          (x) => DBRowFactory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetSync.fromJson(String source) =>
      GetSync.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetSync(data: $data)';

  @override
  bool operator ==(covariant GetSync<T> other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
