import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/resolved_tool_use.dart';
import 'package:pump_progress_frontend/features/exercise/domain/exercise.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

void main() {
  late MockRepositoryExercises mockRepo;
  late AiToolDispatcher dispatcher;

  setUp(() {
    mockRepo = MockRepositoryExercises();
    dispatcher = AiToolDispatcher(repositoryExercises: mockRepo);
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
        args: {'muscle': 'biceps'},
      );
      final resolved = dispatcher.resolve(call);
      expect(resolved.message, contains('biceps'));
    });

    test('execute calls repository and returns exercises map', () async {
      when(() => mockRepo.getExercisesByMuscle('chest', limit: any(named: 'limit')))
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
