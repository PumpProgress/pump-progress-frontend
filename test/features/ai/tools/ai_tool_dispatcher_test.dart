import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/resolved_tool_use.dart';
import 'package:pump_progress_frontend/features/exercise/domain/exercise.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/domain/muscle.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

class MockProviderMuscle extends Mock implements ProviderMuscle {}

void main() {
  late MockRepositoryExercises mockRepo;
  late MockProviderMuscle mockMuscles;
  late AiToolDispatcher dispatcher;

  setUp(() async {
    mockRepo = MockRepositoryExercises();
    mockMuscles = MockProviderMuscle();
    when(() => mockMuscles.getMuscles()).thenAnswer((_) async => [
          Muscle(id: 1, name: 'chest', code: 'chest'),
          Muscle(id: 2, name: 'biceps', code: 'biceps'),
        ]);
    dispatcher = AiToolDispatcher(
      repositoryExercises: mockRepo,
      providerMuscle: mockMuscles,
    );
    await dispatcher.init();
  });

  group('AiToolDispatcher.init', () {
    test('populates tool enum with muscle names from provider', () {
      final muscleEnum =
          ((dispatcher.tools.first.parameters['properties']
                  as Map<String, dynamic>)['muscle']
              as Map<String, dynamic>)['enum'] as List;
      expect(muscleEnum, equals(['chest', 'biceps']));
    });
  });

  group('AiToolDispatcher.tools', () {
    test('returns a non-empty list of Tool objects', () {
      expect(dispatcher.tools, isNotEmpty);
    });

    test('includes get_exercises_by_muscle', () {
      final names = dispatcher.tools.map((t) => t.name).toList();
      expect(names, contains('get_exercises_by_muscle'));
    });
  });

  group('AiToolDispatcher.resolve', () {
    test('returns ResolvedToolUse for get_exercises_by_muscle', () {
      final call = FunctionCallResponse(
        name: 'get_exercises_by_muscle',
        args: {'muscle': 'chest'},
      );
      final resolved = dispatcher.resolve(call);
      expect(resolved, isA<ResolvedToolUse>());
    });

    test('message interpolates muscle arg', () {
      final call = FunctionCallResponse(
        name: 'get_exercises_by_muscle',
        args: {'muscle': 'chest'},
      );
      final resolved = dispatcher.resolve(call);
      expect(resolved.message, contains('chest'));
    });

    test('execute calls repository and returns exercises map', () async {
      when(() => mockRepo.getExercisesByMuscle('chest',
              limit: any(named: 'limit')))
          .thenAnswer((_) async => [
                const Exercise(
                  id: 1,
                  name: 'Bench Press',
                  category: 'Compound',
                  muscles: ['chest'],
                ),
              ]);

      final call = FunctionCallResponse(
        name: 'get_exercises_by_muscle',
        args: {'muscle': 'chest', 'limit': 5},
      );
      final resolved = dispatcher.resolve(call);
      final result = await resolved.execute();
      expect(result['exercises'], isA<List>());
      expect((result['exercises'] as List).first['name'], 'Bench Press');
    });

    test('throws StateError for unknown tool name', () {
      final call = FunctionCallResponse(
        name: 'non_existent_tool',
        args: {},
      );
      expect(() => dispatcher.resolve(call), throwsStateError);
    });
  });
}
