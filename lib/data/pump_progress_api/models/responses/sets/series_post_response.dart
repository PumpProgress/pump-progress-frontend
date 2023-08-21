import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sets/series_api.dart';

@immutable
class SeriesPostResponse {
  final SeriesAPI data;
  const SeriesPostResponse({
    required this.data,
  });

  SeriesPostResponse copyWith({
    SeriesAPI? data,
  }) {
    return SeriesPostResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory SeriesPostResponse.fromMap(Map<String, dynamic> map) {
    return SeriesPostResponse(
      data: SeriesAPI.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SeriesPostResponse.fromJson(String source) =>
      SeriesPostResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SeriesPostResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SeriesPostResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
