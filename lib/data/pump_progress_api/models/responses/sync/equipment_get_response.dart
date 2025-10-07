import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sync/equipment_row_api.dart';

class EquipmentGetResponse {
  final List<EquipmentRowAPI> data;
  EquipmentGetResponse({
    required this.data,
  });

  EquipmentGetResponse copyWith({
    List<EquipmentRowAPI>? data,
  }) {
    return EquipmentGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory EquipmentGetResponse.fromMap(Map<String, dynamic> map) {
    return EquipmentGetResponse(
      data: List<EquipmentRowAPI>.from(
        (map['data'] as List<dynamic>).map<EquipmentRowAPI>(
          (x) => EquipmentRowAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EquipmentGetResponse.fromJson(String source) =>
      EquipmentGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EquipmentGetResponse(data: $data)';

  @override
  bool operator ==(covariant EquipmentGetResponse other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
