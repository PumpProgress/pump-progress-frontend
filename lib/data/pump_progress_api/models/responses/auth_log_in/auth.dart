import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Auth {
  const Auth({
    required this.data,
  });

  final String data;

  Auth copyWith({
    String? data,
  }) {
    return Auth(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      data: map['data'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Auth.fromJson(String source) =>
      Auth.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Auth(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Auth && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
