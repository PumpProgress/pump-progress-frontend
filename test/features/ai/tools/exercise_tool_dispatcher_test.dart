import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/tools/exercise_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/domain/muscle.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/services/current_user_service.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
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

  setUpAll(() {
    registerFallbackValue(const Exercise.empty());
  });

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

  group('save_weekly_plan', () {
    Exercise ex(int id, String name) =>
        Exercise(id: id, name: name, category: 'push', muscles: const ['chest']);

    void stubAuthedUser() {
      when(() => userService.getCurrentUser()).thenAnswer((_) async => const User(
            id: 'u1',
            name: '',
            email: '',
            favoriteExercises: [],
            trainingDaysPerWeek: 2,
          ));
    }

    test('exposes save_weekly_plan alongside the lookup tool', () async {
      stubAuthedUser();
      final dispatcher = build();
      await dispatcher.init();
      final names = dispatcher.tools.map((t) => t.name).toList();
      expect(names, containsAll(['get_exercises_by_muscle', 'save_weekly_plan']));
    });

    test('creates a workout per day and adds resolved exercises', () async {
      stubAuthedUser();
      when(() => exercises.searchExercises('Bench Press'))
          .thenAnswer((_) async => [ex(10, 'Bench Press')]);
      when(() => exercises.searchExercises('Squat'))
          .thenAnswer((_) async => [ex(20, 'Squat')]);
      when(() => workouts.createWorkout(
              userId: any(named: 'userId'), name: any(named: 'name')))
          .thenAnswer((inv) async => Workout.empty(
              id: 'w-${inv.namedArguments[#name]}',
              name: inv.namedArguments[#name] as String,
              userId: 'u1'));
      when(() => workouts.addExerciseToWorkout(
            workoutId: any(named: 'workoutId'),
            exerciseId: any(named: 'exerciseId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => const Workout.empty());

      final dispatcher = build();
      await dispatcher.init();
      final resolved = dispatcher.resolve(FunctionCallResponse(
        name: 'save_weekly_plan',
        args: {
          'workouts': [
            {'name': 'Push Day', 'exercises': ['Bench Press']},
            {'name': 'Leg Day', 'exercises': ['Squat']},
          ],
        },
      ));
      final result = await resolved.execute();

      expect(result['status'], 'saved');
      verify(() => workouts.createWorkout(userId: 'u1', name: 'Push Day'))
          .called(1);
      verify(() => workouts.createWorkout(userId: 'u1', name: 'Leg Day'))
          .called(1);
      verify(() => workouts.addExerciseToWorkout(
          workoutId: 'w-Push Day', exerciseId: 10, userId: 'u1')).called(1);
      final summary = result['display_message'] as String;
      expect(summary, contains('Push Day'));
      expect(summary, contains('Bench Press'));
    });

    test('collects unmatched names and skips an all-unmatched day', () async {
      stubAuthedUser();
      when(() => exercises.searchExercises('Bench Press'))
          .thenAnswer((_) async => [ex(10, 'Bench Press')]);
      when(() => exercises.searchExercises('Nonsense Lift'))
          .thenAnswer((_) async => <Exercise>[]);
      when(() => workouts.createWorkout(
              userId: any(named: 'userId'), name: any(named: 'name')))
          .thenAnswer((inv) async => Workout.empty(
              id: 'w1', name: inv.namedArguments[#name] as String, userId: 'u1'));
      when(() => workouts.addExerciseToWorkout(
            workoutId: any(named: 'workoutId'),
            exerciseId: any(named: 'exerciseId'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => const Workout.empty());

      final dispatcher = build();
      await dispatcher.init();
      final result = await dispatcher
          .resolve(FunctionCallResponse(name: 'save_weekly_plan', args: {
        'workouts': [
          {'name': 'Push Day', 'exercises': ['Bench Press', 'Nonsense Lift']},
          {'name': 'Empty Day', 'exercises': ['Nonsense Lift']},
        ],
      })).execute();

      expect(result['status'], 'saved');
      expect(result['unmatched'], contains('Nonsense Lift'));
      verify(() => workouts.createWorkout(userId: 'u1', name: 'Push Day'))
          .called(1);
      verifyNever(
          () => workouts.createWorkout(userId: 'u1', name: 'Empty Day'));
    });

    test('returns an error and creates nothing when unauthenticated', () async {
      when(() => userService.getCurrentUser()).thenAnswer((_) async => null);
      final dispatcher = build();
      await dispatcher.init();
      final result = await dispatcher
          .resolve(FunctionCallResponse(name: 'save_weekly_plan', args: {
        'workouts': [
          {'name': 'Push Day', 'exercises': ['Bench Press']},
        ],
      })).execute();

      expect(result['status'], 'error');
      verifyNever(() => workouts.createWorkout(
          userId: any(named: 'userId'), name: any(named: 'name')));
    });

    test('returns an error for empty or malformed workouts', () async {
      stubAuthedUser();
      final dispatcher = build();
      await dispatcher.init();
      final result = await dispatcher
          .resolve(FunctionCallResponse(
              name: 'save_weekly_plan', args: {'workouts': []}))
          .execute();
      expect(result['status'], 'error');
    });

    test('returns an error when workouts is not a list', () async {
      stubAuthedUser();
      final dispatcher = build();
      await dispatcher.init();
      final result = await dispatcher
          .resolve(FunctionCallResponse(
              name: 'save_weekly_plan', args: {'workouts': 'nope'}))
          .execute();
      expect(result['status'], 'error');
      verifyNever(() => workouts.createWorkout(
          userId: any(named: 'userId'), name: any(named: 'name')));
    });
  });
}
