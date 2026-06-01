// test/features/ai/blocs/workout_builder_chat_bloc_test.dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/ai/tools/exercise_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/domain/muscle.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

class MockInferenceModel extends Mock implements InferenceModel {}

class MockInferenceChat extends Mock implements InferenceChat {}

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

class MockProviderMuscle extends Mock implements ProviderMuscle {}

void main() {
  late MockGemmaModelService mockService;
  late MockInferenceModel mockModel;
  late MockInferenceChat mockChat;
  late StreamController<InferenceModel> modelStreamController;
  late AiToolDispatcher dispatcher;
  late MockRepositoryExercises mockRepo;
  late MockProviderMuscle mockMuscles;

  setUpAll(() {
    registerFallbackValue(const Message(text: ''));
  });

  setUp(() {
    mockService = MockGemmaModelService();
    mockModel = MockInferenceModel();
    mockChat = MockInferenceChat();
    modelStreamController = StreamController<InferenceModel>.broadcast();
    mockRepo = MockRepositoryExercises();
    mockMuscles = MockProviderMuscle();

    when(() => mockMuscles.getMuscles()).thenAnswer((_) async => [
          Muscle(id: 1, name: 'chest', code: 'chest'),
        ]);
    dispatcher = ExerciseToolDispatcher(
      repositoryExercises: mockRepo,
      providerMuscle: mockMuscles,
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
  });
}
