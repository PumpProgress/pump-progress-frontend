import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sets/series_api.dart';

@immutable
class SetsGetResponse {
  final List<SeriesAPI> data;
  const SetsGetResponse({
    required this.data,
  });

  SetsGetResponse copyWith({
    List<SeriesAPI>? data,
  }) {
    return SetsGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory SetsGetResponse.fromMap(Map<String, dynamic> map) {
    return SetsGetResponse(
      data: map['data'] == null
          ? []
          : List<SeriesAPI>.from(map['data']
                  ?.map((x) => SeriesAPI.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SetsGetResponse.fromJson(String source) =>
      SetsGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SetsGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SetsGetResponse && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
