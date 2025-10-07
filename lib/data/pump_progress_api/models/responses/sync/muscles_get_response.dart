// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sync/muscles_row_api.dart';

class MusclesGetResponse {
  final List<MuscleRowAPI> data;

  MusclesGetResponse({
    required this.data,
  });

  MusclesGetResponse copyWith({
    List<MuscleRowAPI>? data,
  }) {
    return MusclesGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory MusclesGetResponse.fromMap(Map<String, dynamic> map) {
    return MusclesGetResponse(
      data: List<MuscleRowAPI>.from(
        (map['data'] as List<dynamic>).map<MuscleRowAPI>(
          (x) => MuscleRowAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusclesGetResponse.fromJson(String source) =>
      MusclesGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MusclesGetResponse(data: $data)';

  @override
  bool operator ==(covariant MusclesGetResponse other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
