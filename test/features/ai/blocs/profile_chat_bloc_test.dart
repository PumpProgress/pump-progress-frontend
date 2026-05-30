// test/features/ai/blocs/profile_chat_bloc_test.dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

class MockInferenceModel extends Mock implements InferenceModel {}

class MockInferenceChat extends Mock implements InferenceChat {}

void main() {
  late MockGemmaModelService mockService;
  late MockInferenceModel mockModel;
  late MockInferenceChat mockChat;
  late StreamController<InferenceModel> modelStreamController;

  setUpAll(() {
    registerFallbackValue(const Message(text: ''));
  });

  setUp(() {
    mockService = MockGemmaModelService();
    mockModel = MockInferenceModel();
    mockChat = MockInferenceChat();
    modelStreamController = StreamController<InferenceModel>.broadcast();

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
    when(
      () => mockChat.addQueryChunk(any()),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    modelStreamController.close();
  });

  group('ProfileChatBloc', () {
    test('has empty tools list', () {
      final bloc = ProfileChatBloc(modelService: mockService);
      expect(bloc.tools, isEmpty);
      expect(bloc.toolDispatcher, isNull);
      bloc.close();
    });

    test('has non-empty systemPrompt', () {
      final bloc = ProfileChatBloc(modelService: mockService);
      expect(bloc.systemPrompt, isNotEmpty);
      bloc.close();
    });

    blocTest<ProfileChatBloc, ChatState>(
      'emits isReady:true when model stream emits',
      build: () => ProfileChatBloc(modelService: mockService),
      act: (bloc) => modelStreamController.add(mockModel),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        isA<ChatState>().having((s) => s.isReady, 'isReady', isTrue),
      ],
    );

    blocTest<ProfileChatBloc, ChatState>(
      'does not process SendMessageEvent when not ready',
      build: () => ProfileChatBloc(modelService: mockService),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => <ChatState>[],
    );
  });
}
