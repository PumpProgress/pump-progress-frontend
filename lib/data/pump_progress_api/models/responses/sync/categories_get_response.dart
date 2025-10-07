import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/sync/category_api.dart';

class CategoriesGetResponse {
  CategoriesGetResponse({
    required this.data,
  });

  final List<CategoryAPI> data;

  CategoriesGetResponse copyWith({
    List<CategoryAPI>? data,
  }) {
    return CategoriesGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoriesGetResponse.fromMap(Map<String, dynamic> map) {
    return CategoriesGetResponse(
      data: List<CategoryAPI>.from(
        (map['data'] as List<dynamic>).map<CategoryAPI>(
          (x) => CategoryAPI.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesGetResponse.fromJson(String source) =>
      CategoriesGetResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoriesGetResponse(data: $data)';

  @override
  bool operator ==(covariant CategoriesGetResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
