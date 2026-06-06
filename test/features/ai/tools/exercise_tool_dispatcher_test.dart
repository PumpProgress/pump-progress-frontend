import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/tools/exercise_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/domain/muscle.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/services/current_user_service.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository.dart';

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

class MockProviderMuscle extends Mock implements ProviderMuscle {}

class MockRepositoryWorkout extends Mock implements RepositoryWorkout {}

class MockCurrentUserService extends Mock implements CurrentUserService {}

void main() {
  late MockRepositoryExercises exercises;
  late MockProviderMuscle muscles;
  late MockRepositoryWorkout workouts;
  late MockCurrentUserService userService;

  setUp(() {
    exercises = MockRepositoryExercises();
    muscles = MockProviderMuscle();
    workouts = MockRepositoryWorkout();
    userService = MockCurrentUserService();

    when(() => muscles.getMuscles())
        .thenAnswer((_) async => [Muscle(id: 1, name: 'chest', code: 'chest')]);
    when(() => userService.getCurrentUser()).thenAnswer((_) async => null);
  });

  ExerciseToolDispatcher build() => ExerciseToolDispatcher(
        repositoryExercises: exercises,
        providerMuscle: muscles,
        repositoryWorkout: workouts,
        currentUserService: userService,
      );

  test('keeps the get_exercises_by_muscle tool', () async {
    final dispatcher = build();
    await dispatcher.init();
    final names = dispatcher.tools.map((t) => t.name).toList();
    expect(names, contains('get_exercises_by_muscle'));
  });

  test('seeds profile getters from the current-user service', () async {
    when(() => userService.getCurrentUser()).thenAnswer((_) async => const User(
          id: 'u1',
          name: '',
          email: '',
          favoriteExercises: [],
          age: 28,
          gender: 'Male',
          fitnessLevel: 'Advanced',
          primaryGoal: 'Build muscle',
          trainingDaysPerWeek: 5,
        ));
    final dispatcher = build();
    await dispatcher.init();

    expect(dispatcher.age, 28);
    expect(dispatcher.gender, 'Male');
    expect(dispatcher.fitnessLevel, 'Advanced');
    expect(dispatcher.primaryGoal, 'Build muscle');
    expect(dispatcher.trainingDaysPerWeek, 5);
  });

  test('profile getters are null when there is no user', () async {
    final dispatcher = build();
    await dispatcher.init();
    expect(dispatcher.age, isNull);
    expect(dispatcher.gender, isNull);
    expect(dispatcher.fitnessLevel, isNull);
    expect(dispatcher.primaryGoal, isNull);
    expect(dispatcher.trainingDaysPerWeek, isNull);
  });
}
