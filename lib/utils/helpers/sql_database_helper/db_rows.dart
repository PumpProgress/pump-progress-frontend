import 'package:pump_progress_frontend/features/category/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/equipment/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/exercise/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/muscle/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/sets/models/entities/entities.dart';
import 'package:pump_progress_frontend/features/workout/models/entities/entities.dart';

abstract class DBRow {
  String get tableName;
  Map<String, dynamic> toDB();
  Map<String, dynamic> toMap();
  String toJson();
}

abstract class DbRowWrite extends DBRow {
  dynamic get id;
}

class DBRowFactory {
  static T fromMap<T extends DBRow>(Map<String, dynamic> map) {
    switch (T) {
      case const (CategoryRow):
        return CategoryRow.fromMap(map) as T;
      case const (EquipmentRow):
        return EquipmentRow.fromMap(map) as T;
      case const (ExerciseRow):
        return ExerciseRow.fromMap(map) as T;
      case const (MuscleRow):
        return MuscleRow.fromMap(map) as T;
      case const (SecondaryMuscleRow):
        return SecondaryMuscleRow.fromMap(map) as T;
      case const (SetsRow):
        return SetsRow.fromMap(map) as T;
      case const (WorkoutExercisesRow):
        return WorkoutExercisesRow.fromMap(map) as T;
      case const (WorkoutRow):
        return WorkoutRow.fromMap(map) as T;
      default:
        throw Exception('Unsupported DBRow type: $T');
    }
  }

  static T fromDB<T extends DBRow>(Map<String, dynamic> map) {
    switch (T) {
      case const (CategoryRow):
        return CategoryRow.fromDB(map) as T;
      case const (EquipmentRow):
        return EquipmentRow.fromDB(map) as T;
      case const (ExerciseRow):
        return ExerciseRow.fromDB(map) as T;
      case const (MuscleRow):
        return MuscleRow.fromDB(map) as T;
      case const (SecondaryMuscleRow):
        return SecondaryMuscleRow.fromDB(map) as T;
      case const (SetsRow):
        return SetsRow.fromDB(map) as T;
      case const (WorkoutExercisesRow):
        return WorkoutExercisesRow.fromDB(map) as T;
      case const (WorkoutRow):
        return WorkoutRow.fromDB(map) as T;
      default:
        throw Exception('Unsupported DBRow type: $T');
    }
  }

  static T fromJson<T extends DBRow>(String json) {
    switch (T) {
      case const (CategoryRow):
        return CategoryRow.fromJson(json) as T;
      case const (EquipmentRow):
        return EquipmentRow.fromJson(json) as T;
      case const (ExerciseRow):
        return ExerciseRow.fromJson(json) as T;
      case const (MuscleRow):
        return MuscleRow.fromJson(json) as T;
      case const (SecondaryMuscleRow):
        return SecondaryMuscleRow.fromJson(json) as T;
      case const (SetsRow):
        return SetsRow.fromJson(json) as T;
      case const (WorkoutExercisesRow):
        return WorkoutExercisesRow.fromJson(json) as T;
      case const (WorkoutRow):
        return WorkoutRow.fromJson(json) as T;
      default:
        throw Exception('Unsupported DBRow type: $T');
    }
  }
}
