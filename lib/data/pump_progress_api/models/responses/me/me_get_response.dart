import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/me/me.dart';

@immutable
class MeGetResponse {
  final Me data;
  MeGetResponse({
    required this.data,
  });

  MeGetResponse copyWith({
    Me? data,
  }) {
    return MeGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory MeGetResponse.fromMap(Map<String, dynamic> map) {
    return MeGetResponse(
      data: Me.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeGetResponse.fromJson(String source) =>
      MeGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MeGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeGetResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
