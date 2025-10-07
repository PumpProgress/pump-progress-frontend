import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sync/secondary_muscles_row_api.dart';

class SecondaryMusclesGetResponse {
  final List<SecondaryMusclesRowAPI> data;
  SecondaryMusclesGetResponse({
    required this.data,
  });

  SecondaryMusclesGetResponse copyWith({
    List<SecondaryMusclesRowAPI>? data,
  }) {
    return SecondaryMusclesGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory SecondaryMusclesGetResponse.fromMap(Map<String, dynamic> map) {
    return SecondaryMusclesGetResponse(
      data: List<SecondaryMusclesRowAPI>.from(
        (map['data'] as List<dynamic>).map<SecondaryMusclesRowAPI>(
          (x) => SecondaryMusclesRowAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondaryMusclesGetResponse.fromJson(String source) =>
      SecondaryMusclesGetResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SecondaryMusclesGetResponse(data: $data)';

  @override
  bool operator ==(covariant SecondaryMusclesGetResponse other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
