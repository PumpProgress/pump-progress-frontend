// test/features/ai/blocs/profile_chat_bloc_test.dart
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/features/ai/tools/profile_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

class MockGemmaModelService extends Mock implements GemmaModelService {}

class MockInferenceModel extends Mock implements InferenceModel {}

class MockInferenceChat extends Mock implements InferenceChat {}

class MockUserSessionBloc extends Mock implements UserSessionBloc {}

void main() {
  late MockGemmaModelService mockService;
  late MockInferenceModel mockModel;
  late MockInferenceChat mockChat;
  late MockUserSessionBloc mockSession;
  late StreamController<InferenceModel> modelStreamController;

  ProfileToolDispatcher dispatcher() =>
      ProfileToolDispatcher(userSessionBloc: mockSession);

  setUpAll(() {
    registerFallbackValue(const Message(text: ''));
  });

  setUp(() {
    mockService = MockGemmaModelService();
    mockModel = MockInferenceModel();
    mockChat = MockInferenceChat();
    mockSession = MockUserSessionBloc();
    modelStreamController = StreamController<InferenceModel>.broadcast();

    when(() => mockSession.state)
        .thenReturn(const UserSessionState(user: User.unknown));
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
    test('exposes its tool dispatcher', () {
      final bloc = ProfileChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher(),
      );
      expect(bloc.toolDispatcher, isA<ProfileToolDispatcher>());
      bloc.close();
    });

    test('has non-empty systemPrompt seeded with the first missing field', () {
      final bloc = ProfileChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher(),
      );
      expect(bloc.systemPrompt, isNotEmpty);
      // Empty profile → first field to ask for is the name.
      expect(bloc.systemPrompt, contains('name'));
      bloc.close();
    });

    blocTest<ProfileChatBloc, ChatState>(
      'emits isReady:true when model stream emits',
      build: () => ProfileChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher(),
      ),
      act: (bloc) => modelStreamController.add(mockModel),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        isA<ChatState>().having((s) => s.isReady, 'isReady', isTrue),
      ],
    );

    blocTest<ProfileChatBloc, ChatState>(
      'does not process SendMessageEvent when not ready',
      build: () => ProfileChatBloc(
        modelService: mockService,
        toolDispatcher: dispatcher(),
      ),
      act: (bloc) => bloc.add(const SendMessageEvent('Hello')),
      expect: () => <ChatState>[],
    );
  });
}
