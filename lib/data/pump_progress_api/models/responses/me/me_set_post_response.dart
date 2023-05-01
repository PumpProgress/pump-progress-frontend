import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me_sets.dart';

@immutable
class MeSetPostResponse {
  final MeSet data;
  MeSetPostResponse({
    required this.data,
  });

  MeSetPostResponse copyWith({
    MeSet? data,
  }) {
    return MeSetPostResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory MeSetPostResponse.fromMap(Map<String, dynamic> map) {
    return MeSetPostResponse(
      data: MeSet.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeSetPostResponse.fromJson(String source) =>
      MeSetPostResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MeSetPostResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeSetPostResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
