import 'dart:convert';

@Deprecated('No longer sand email and password, use aws cognito for auth')
class AuthLogInBody {
  AuthLogInBody({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  AuthLogInBody copyWith({
    String? email,
    String? password,
  }) {
    return AuthLogInBody(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AuthLogInBody.fromMap(Map<String, dynamic> map) {
    return AuthLogInBody(
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthLogInBody.fromJson(String source) =>
      AuthLogInBody.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AuthLogInBody(email: $email, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLogInBody &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
