import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pump_progress_frontend/data/pump_progress_api/models/responses/auth_log_in/auth.dart';

@immutable
class AuthLogInResponse {
  const AuthLogInResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final Auth data;

  AuthLogInResponse copyWith({
    int? status,
    String? message,
    Auth? data,
  }) {
    return AuthLogInResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory AuthLogInResponse.fromMap(Map<String, dynamic> map) {
    return AuthLogInResponse(
      status: map['status']?.toInt() as int,
      message: map['message'] as String,
      data: Auth.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthLogInResponse.fromJson(String source) =>
      AuthLogInResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthLogInResponse(status: $status, message: $message, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLogInResponse &&
        other.status == status &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ data.hashCode;
}
