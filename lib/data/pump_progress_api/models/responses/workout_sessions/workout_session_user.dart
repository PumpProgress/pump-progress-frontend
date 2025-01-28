part of 'workout_session.dart';

class WorkoutSessionUserAPI {
  final String id;
  final String name;
  final String email;
  WorkoutSessionUserAPI({
    required this.id,
    required this.name,
    required this.email,
  });

  WorkoutSessionUserAPI copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return WorkoutSessionUserAPI(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory WorkoutSessionUserAPI.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionUserAPI(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSessionUserAPI.fromJson(String source) =>
      WorkoutSessionUserAPI.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WorkoutSessionUserAPI(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(covariant WorkoutSessionUserAPI other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}
