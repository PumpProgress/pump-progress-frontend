// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SeriesCalendarAPI {
  final String name;
  final String exerciseId;
  SeriesCalendarAPI({
    required this.name,
    required this.exerciseId,
  });

  SeriesCalendarAPI copyWith({
    String? name,
    String? exerciseId,
  }) {
    return SeriesCalendarAPI(
      name: name ?? this.name,
      exerciseId: exerciseId ?? this.exerciseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'exerciseId': exerciseId,
    };
  }

  factory SeriesCalendarAPI.fromMap(Map<String, dynamic> map) {
    return SeriesCalendarAPI(
      name: map['name'] as String,
      exerciseId: map['exerciseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeriesCalendarAPI.fromJson(String source) =>
      SeriesCalendarAPI.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SeriesCalendarAPI(name: $name, exerciseId: $exerciseId)';

  @override
  bool operator ==(covariant SeriesCalendarAPI other) {
    if (identical(this, other)) return true;

    return other.name == name && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => name.hashCode ^ exerciseId.hashCode;
}
