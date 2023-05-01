import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_sets.dart';

@immutable
class MeSetsGetResponse {
  final List<MeSet> data;
  MeSetsGetResponse({
    required this.data,
  });

  MeSetsGetResponse copyWith({
    List<MeSet>? data,
  }) {
    return MeSetsGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory MeSetsGetResponse.fromMap(Map<String, dynamic> map) {
    return MeSetsGetResponse(
      data: map['data'] == null
          ? []
          : List<MeSet>.from(
              map['data']?.map((x) => MeSet.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeSetsGetResponse.fromJson(String source) =>
      MeSetsGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MeSetsGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeSetsGetResponse && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
