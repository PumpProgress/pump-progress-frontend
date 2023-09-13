import 'dart:convert';

class WorkoutPostBody {
  String name;
  WorkoutPostBody({
    required this.name,
  });

  WorkoutPostBody copyWith({
    String? name,
  }) {
    return WorkoutPostBody(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory WorkoutPostBody.fromMap(Map<String, dynamic> map) {
    return WorkoutPostBody(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutPostBody.fromJson(String source) =>
      WorkoutPostBody.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutPostBody(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutPostBody && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
