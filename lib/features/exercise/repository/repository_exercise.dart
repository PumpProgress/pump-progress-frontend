import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/local/local.dart';

class RepositoryExercises {
  final LocalExercise localExercise = LocalExercise();

  Future<List<Exercise>> getExercises({List<int>? exerciseIds}) async {
    final exerciseRows =
        await localExercise.getExercises(exerciseIds: exerciseIds);
    final exercises = exerciseRows
        .map((exerciseRow) => Exercise.fromMap(exerciseRow.toMap()))
        .toList();
    return exercises;
  }

  Future<Exercise> getExerciseById(int exerciseId) async {
    final exerciseRow = await localExercise.getExerciseById(exerciseId);
    return Exercise.fromMap(exerciseRow.toMap());
  }

  Future<List<Exercise>> getExercisesByMuscle(
    String muscleName, {
    int limit = 10,
  }) async {
    final exerciseRows = await localExercise.getExercisesByMuscle(
      muscleName: muscleName,
      limit: limit,
    );
    return exerciseRows
        .map((exerciseRow) => Exercise.fromMap(exerciseRow.toMap()))
        .toList();
  }

  Future<List<Exercise>> getAllExercises() async {
    final maps = await localExercise.getAllExercisesEnriched();
    return maps.map(Exercise.fromMap).toList();
  }
}
