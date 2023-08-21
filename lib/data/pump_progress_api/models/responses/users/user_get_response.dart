import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/users/user_api.dart';

@immutable
class UserGetResponse {
  final UserAPI data;
  const UserGetResponse({
    required this.data,
  });

  UserGetResponse copyWith({
    UserAPI? data,
  }) {
    return UserGetResponse(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toMap(),
    };
  }

  factory UserGetResponse.fromMap(Map<String, dynamic> map) {
    return UserGetResponse(
      data: UserAPI.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGetResponse.fromJson(String source) =>
      UserGetResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserGetResponse(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserGetResponse && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
