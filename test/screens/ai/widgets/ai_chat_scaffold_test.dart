import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/screens/ai/widgets/ai_chat_scaffold.dart';

class MockGemmaModelBloc extends MockBloc<GemmaModelEvent, GemmaModelState>
    implements GemmaModelBloc {}

class MockProfileChatBloc extends MockBloc<ChatEvent, ChatState>
    implements ProfileChatBloc {}

Widget _wrap(
  Widget child, {
  required MockGemmaModelBloc modelBloc,
  required MockProfileChatBloc chatBloc,
}) =>
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GemmaModelBloc>.value(value: modelBloc),
          BlocProvider<ProfileChatBloc>.value(value: chatBloc),
        ],
        child: child,
      ),
    );

void main() {
  late MockGemmaModelBloc modelBloc;
  late MockProfileChatBloc chatBloc;

  setUp(() {
    modelBloc = MockGemmaModelBloc();
    chatBloc = MockProfileChatBloc();
    when(() => modelBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => chatBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => chatBloc.state).thenReturn(const ChatState());
    addTearDown(() => modelBloc.close());
    addTearDown(() => chatBloc.close());
  });

  group('AiChatScaffold — loading states', () {
    testWidgets('shows indeterminate spinner when GemmaModelStatusInitial',
        (tester) async {
      when(() => modelBloc.state)
          .thenReturn(const GemmaModelState(status: GemmaModelStatusInitial()));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Getting AI ready…'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets(
        'shows determinate bar and percentage when GemmaModelStatusInstalling',
        (tester) async {
      when(() => modelBloc.state).thenReturn(const GemmaModelState(
        status: GemmaModelStatusInstalling(),
        downloadProgress: 45,
      ));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Getting AI ready…'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.45, 0.001));
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows download subtitle when GemmaModelStatusInstalling',
        (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusInstalling()),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(
        find.text('Downloading model for the first time. This only happens once.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'does not show download subtitle when GemmaModelStatusInitial',
        (tester) async {
      when(() => modelBloc.state)
          .thenReturn(const GemmaModelState(status: GemmaModelStatusInitial()));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(
        find.text('Downloading model for the first time. This only happens once.'),
        findsNothing,
      );
    });
  });

  group('AiChatScaffold — error state', () {
    testWidgets('shows error message and retry button', (tester) async {
      when(() => modelBloc.state).thenReturn(
        GemmaModelState(status: GemmaModelStatusError('Network error')),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('retry button dispatches GemmaModelInitEvent', (tester) async {
      when(() => modelBloc.state).thenReturn(
        GemmaModelState(status: GemmaModelStatusError('fail')),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      await tester.tap(find.text('Retry'));
      verify(() => modelBloc.add(const GemmaModelInitEvent())).called(1);
    });
  });

  group('AiChatScaffold — loaded state', () {
    testWidgets('shows enabled input when ready and not generating',
        (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(const ChatState(isReady: true));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isTrue);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('input is disabled when isGenerating', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(
        const ChatState(isReady: true, isGenerating: true),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, false);
    });

    testWidgets('send button dispatches SendMessageEvent', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(const ChatState(isReady: true));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.tap(find.byIcon(Icons.send));
      verify(() => chatBloc.add(const SendMessageEvent('Hello AI'))).called(1);
    });

    testWidgets('send button is disabled when isGenerating', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(
        const ChatState(isReady: true, isGenerating: true),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows user and AI messages', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(
        const ChatState(
          isReady: true,
          messages: [
            ChatMessage(text: 'Hello', isUser: true),
            ChatMessage(text: 'Hi there', isUser: false),
          ],
        ),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there'), findsOneWidget);
    });

    testWidgets('AI streaming message shows trailing ellipsis', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(
        const ChatState(
          isReady: true,
          isGenerating: true,
          messages: [
            ChatMessage(text: 'Thinking', isUser: false, isStreaming: true),
          ],
        ),
      );
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Test'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Thinking…'), findsOneWidget);
    });

    testWidgets('AppBar shows the provided title', (tester) async {
      when(() => modelBloc.state).thenReturn(
        const GemmaModelState(status: GemmaModelStatusReady()),
      );
      when(() => chatBloc.state).thenReturn(const ChatState(isReady: true));
      await tester.pumpWidget(_wrap(
        const AiChatScaffold<ProfileChatBloc>(title: 'Build Workout'),
        modelBloc: modelBloc,
        chatBloc: chatBloc,
      ));
      expect(find.text('Build Workout'), findsOneWidget);
    });
  });
}
