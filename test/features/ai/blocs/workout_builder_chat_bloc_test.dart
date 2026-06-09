// test/features/ai/blocs/workout_builder_chat_bloc_test.dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/features/ai/tools/exercise_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/domain/muscle.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';
import 'package:pump_progress_frontend/features/user/services/current_user_service.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

class MockInferenceModel extends Mock implements InferenceModel {}

class MockInferenceChat extends Mock implements InferenceChat {}

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

class MockProviderMuscle extends Mock implements ProviderMuscle {}

class MockRepositoryWorkout extends Mock implements RepositoryWorkout {}

class MockCurrentUserService extends Mock implements CurrentUserService {}

void main() {
  late MockGemmaModelService mockService;
  late MockInferenceModel mockModel;
  late MockInferenceChat mockChat;
  late StreamController<InferenceModel> modelStreamController;
  late ExerciseToolDispatcher dispatcher;
  late MockRepositoryExercises mockRepo;
  late MockProviderMuscle mockMuscles;
  late MockRepositoryWorkout mockWorkout;
  late MockCurrentUserService mockUserService;

  setUpAll(() {
    registerFallbackValue(const Message(text: ''));
    registerFallbackValue(const Exercise.empty());
  });

  setUp(() {
    mockService = MockGemmaModelService();
    mockModel = MockInferenceModel();
    mockChat = MockInferenceChat();
    modelStreamController = StreamController<InferenceModel>.broadcast();
    mockRepo = MockRepositoryExercises();
    mockMuscles = MockProviderMuscle();

    mockWorkout = MockRepositoryWorkout();
    mockUserService = MockCurrentUserService();
    when(() => mockMuscles.getMuscles()).thenAnswer((_) async => [
          Muscle(id: 1, name: 'chest', code: 'chest'),
        ]);
    when(() => mockUserService.getCurrentUser()).thenAnswer((_) async => null);
    dispatcher = ExerciseToolDispatcher(
      repositoryExercises: mockRepo,
      providerMuscle: mockMuscles,
      repositoryWorkout: mockWorkout,
      currentUserService: mockUserService,
    );

    when(() => mockService.hasActiveModel).thenReturn(false);
    when(() => mockService.modelStream)
        .thenAnswer((_) => modelStreamController.stream);
    when(
      () => mockModel.createChat(
        supportsFunctionCalls: any(named: 'supportsFunctionCalls'),
        tools: any(named: 'tools'),
        modelType: any(named: 'modelType'),
      ),
    ).thenAnswer((_) async => mockChat);
    when(() => mockChat.addQueryChunk(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    modelStreamController.close();
  });

  group('WorkoutBuilderChatBloc', () {
    test('has non-empty systemPrompt', () {
      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      expect(bloc.systemPrompt, isNotEmpty);
      bloc.close();
    });

    test('exposes toolDispatcher', () {
      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      expect(bloc.toolDispatcher, isNotNull);
      bloc.close();
    });

    test('systemPrompt reflects the user snapshot after dispatcher init', () async {
      when(() => mockUserService.getCurrentUser()).thenAnswer((_) async => const User(
            id: 'u1',
            name: '',
            email: '',
            favoriteExercises: [],
            fitnessLevel: 'Advanced',
            primaryGoal: 'Build muscle',
            trainingDaysPerWeek: 5,
          ));
      await dispatcher.init();
      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      final prompt = bloc.systemPrompt;
      expect(prompt, contains('Training days per week: 5'));
      expect(prompt, contains('exactly 5 workouts'));
      expect(prompt, contains('Advanced'));
      expect(prompt, contains('Build muscle'));
      expect(prompt, contains('save_weekly_plan'));
      await bloc.close();
    });

    test('prompt curbs exercise lookups to protect the context budget',
        () async {
      await dispatcher.init();
      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      final prompt = bloc.systemPrompt.toLowerCase();
      // The model must know lookups are optional and bounded, or it fans out
      // across many muscles and exhausts the 2048-token window.
      expect(prompt, contains('get_exercises_by_muscle'));
      expect(prompt, contains('at most'));
      await bloc.close();
    });

    test('prompt forbids a prose plan and mandates the save_weekly_plan call',
        () async {
      await dispatcher.init();
      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      final prompt = bloc.systemPrompt.toLowerCase();
      // The DB write is the goal; small models narrate instead of calling the
      // tool when told to "list exercises in chat", so the prompt must forbid
      // the prose plan and make the tool call the only delivery path.
      expect(prompt, contains('do not'));
      expect(prompt, contains('only way'));
      await bloc.close();
    });

    blocTest<WorkoutBuilderChatBloc, ChatState>(
      'emits isReady:true after model ready and dispatcher.init()',
      build: () => WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      ),
      act: (bloc) => modelStreamController.add(mockModel),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ChatState>().having((s) => s.isReady, 'isReady', isTrue),
      ],
    );

    test('dispatches every sequential tool call, not just the first', () async {
      // The model explores two muscles before finishing: it calls
      // get_exercises_by_muscle for chest, then again for triceps, then
      // produces a closing text turn.
      when(() => mockMuscles.getMuscles()).thenAnswer((_) async => [
            Muscle(id: 1, name: 'chest', code: 'chest'),
            Muscle(id: 2, name: 'triceps', code: 'triceps'),
          ]);
      when(() => mockRepo.getExercisesByMuscle(any(),
          limit: any(named: 'limit'))).thenAnswer((_) async => const [
            Exercise.empty(),
          ]);

      final turns = <Stream<ModelResponse>>[
        Stream.fromIterable(const [
          FunctionCallResponse(
              name: 'get_exercises_by_muscle', args: {'muscle': 'chest'}),
        ]),
        Stream.fromIterable(const [
          FunctionCallResponse(
              name: 'get_exercises_by_muscle', args: {'muscle': 'triceps'}),
        ]),
        Stream.fromIterable(const [TextResponse('All set!')]),
      ];
      var turn = 0;
      when(() => mockChat.generateChatResponseAsync()).thenAnswer((_) {
        final index = turn < turns.length ? turn : turns.length - 1;
        turn++;
        return turns[index];
      });

      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      modelStreamController.add(mockModel);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(const SendMessageEvent('Build my week'));
      await Future<void>.delayed(const Duration(milliseconds: 100));

      verify(() => mockRepo.getExercisesByMuscle('chest',
          limit: any(named: 'limit'))).called(1);
      verify(() => mockRepo.getExercisesByMuscle('triceps',
          limit: any(named: 'limit'))).called(1);
      await bloc.close();
    });

    test('dispatches a parallel tool-call turn and hides its raw JSON',
        () async {
      // Reproduces the real gemma4 behaviour: the model batches several
      // get_exercises_by_muscle calls in one turn. flutter_gemma leaks each
      // tool-call chunk's raw JSON onto the text channel (chunks without a
      // `content` field pass through verbatim) and then surfaces the batch as
      // a single ParallelFunctionCallResponse.
      when(() => mockMuscles.getMuscles()).thenAnswer((_) async => [
            Muscle(id: 1, name: 'chest', code: 'chest'),
            Muscle(id: 2, name: 'triceps', code: 'triceps'),
          ]);
      when(() => mockRepo.getExercisesByMuscle(any(),
          limit: any(named: 'limit'))).thenAnswer((_) async => const [
            Exercise.empty(),
          ]);

      const leakedJson =
          '{"role":"assistant","tool_calls":[{"type":"function","function":'
          '{"name":"get_exercises_by_muscle","arguments":'
          '{"muscle":"<|"|>chest<|"|>"}}}]}';

      final turns = <Stream<ModelResponse>>[
        Stream.fromIterable(const [
          TextResponse(leakedJson),
          ParallelFunctionCallResponse(calls: [
            FunctionCallResponse(
                name: 'get_exercises_by_muscle', args: {'muscle': 'chest'}),
            FunctionCallResponse(
                name: 'get_exercises_by_muscle', args: {'muscle': 'triceps'}),
          ]),
        ]),
        Stream.fromIterable(const [TextResponse('All set!')]),
      ];
      var turn = 0;
      when(() => mockChat.generateChatResponseAsync()).thenAnswer((_) {
        final index = turn < turns.length ? turn : turns.length - 1;
        turn++;
        return turns[index];
      });

      final bloc = WorkoutBuilderChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher,
      );
      modelStreamController.add(mockModel);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(const SendMessageEvent('Build my week'));
      await Future<void>.delayed(const Duration(milliseconds: 100));

      verify(() => mockRepo.getExercisesByMuscle('chest',
          limit: any(named: 'limit'))).called(1);
      verify(() => mockRepo.getExercisesByMuscle('triceps',
          limit: any(named: 'limit'))).called(1);
      // The raw tool-call JSON must never be shown to the user as a message.
      expect(
        bloc.state.messages.where((m) => m.text.contains('tool_calls')),
        isEmpty,
      );
      await bloc.close();
    });
  });
}
