import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/local/local.dart';

class RepositoryWorkout {
  final localWorkout = LocalWorkout();
  final localWorkoutExercises = LocalWorkoutExercises();
  final repositoryExercises = RepositoryExercises();

  Future<Workout> getWorkout({required String workoutId}) async {
    final workoutRow = await localWorkout.getWorkout(workoutId: workoutId);
    final workoutExercises = await localWorkoutExercises
        .getWorkoutExercises(workoutIds: [workoutId]);
    final exerciseIds =
        workoutExercises.map((we) => we.exerciseId).toSet().toList();
    final exercises =
        await repositoryExercises.getExercises(exerciseIds: exerciseIds);

    final List<ExerciseAtWorkout> exercisesAtWorkout =
        workoutExercises.map((we) {
      final exercise = exercises.firstWhere((e) => e.id == we.exerciseId);
      return ExerciseAtWorkout(exercise: exercise, seriesToday: 0);
    }).toList();
    List<Map<String, dynamic>> exercisesAtWorkoutMap =
        exercisesAtWorkout.map((e) => e.toMap()).toList();

    return Workout.fromMap({
      ...workoutRow.toMap(),
      'exercises': exercisesAtWorkoutMap,
    });
  }

  Future<List<Workout>> getWorkouts({required String userId}) async {
    final workoutRows = await localWorkout.getWorkouts(userId: userId);
    final workoutIds = workoutRows.map((workout) => workout.id).toList();

    final workoutExercises =
        await localWorkoutExercises.getWorkoutExercises(workoutIds: workoutIds);
    final exercisesIds =
        workoutExercises.map((we) => we.exerciseId).toSet().toList();

    final exercises =
        await repositoryExercises.getExercises(exerciseIds: exercisesIds);

    final workouts = workoutRows.map((workoutRow) {
      final workoutExerciseForWorkout = workoutExercises
          .where((we) => we.workoutId == workoutRow.id)
          .toList();
      final List<ExerciseAtWorkout> exercisesForWorkout =
          workoutExerciseForWorkout.map((we) {
        final exercise = exercises.firstWhere((e) => e.id == we.exerciseId);
        return ExerciseAtWorkout(exercise: exercise, seriesToday: 0);
      }).toList();

      return Workout.fromMap({
        ...workoutRow.toMap(),
        'exercises': exercisesForWorkout.map((e) => e.toMap()).toList(),
      });
    }).toList();
    return workouts;
  }

  Future<Workout> createWorkout(
      {required String userId, required String name}) async {
    final workoutRow =
        await localWorkout.createWorkout(userId: userId, name: name);
    final workout = Workout.fromMap({...workoutRow.toMap(), 'exercises': []});
    return workout;
  }

  Future<Workout> addExerciseToWorkout({
    required String workoutId,
    required int exerciseId,
    required String userId,
  }) async {
    final workoutExerciseRows =
        await localWorkoutExercises.addExerciseToWorkout(
      workoutId: workoutId,
      exerciseId: exerciseId,
      userId: userId,
    );
    final exerciseIds =
        workoutExerciseRows.map((we) => we.exerciseId).toSet().toList();
    final exercises =
        await repositoryExercises.getExercises(exerciseIds: exerciseIds);

    final workoutRow = await localWorkout.getWorkout(workoutId: workoutId);

    final List<ExerciseAtWorkout> exercisesAtWorkout = exercises
        .map((e) => ExerciseAtWorkout(exercise: e, seriesToday: 0))
        .toList();

    final List<Map<String, dynamic>> exercisesAtWorkoutMap =
        exercisesAtWorkout.map((e) => e.toMap()).toList();

    return Workout.fromMap(
        {...workoutRow.toMap(), 'exercises': exercisesAtWorkoutMap});
  }

  Future<Workout> deleteExerciseFromWorkout({
    required String workoutId,
    required int exerciseId,
  }) async {
    final workoutExerciseRows =
        await localWorkoutExercises.deleteExerciseFromWorkout(
      workoutId: workoutId,
      exerciseId: exerciseId,
    );
    final exerciseIds =
        workoutExerciseRows.map((we) => we.exerciseId).toSet().toList();
    final exercises =
        await repositoryExercises.getExercises(exerciseIds: exerciseIds);

    final workoutRow = await localWorkout.getWorkout(workoutId: workoutId);

    final List<ExerciseAtWorkout> exercisesAtWorkout = exercises
        .map((e) => ExerciseAtWorkout(exercise: e, seriesToday: 0))
        .toList();

    final List<Map<String, dynamic>> exercisesAtWorkoutMap =
        exercisesAtWorkout.map((e) => e.toMap()).toList();

    return Workout.fromMap(
        {...workoutRow.toMap(), 'exercises': exercisesAtWorkoutMap});
  }
}
