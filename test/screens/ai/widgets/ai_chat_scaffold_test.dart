import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/screens/ai/widgets/ai_chat_scaffold.dart';

class MockAiBloc extends MockBloc<AiEvent, AiState> implements AiBloc {}

Widget _wrap(Widget child, AiBloc bloc) => MaterialApp(
      home: BlocProvider<AiBloc>.value(value: bloc, child: child),
    );

void main() {
  late MockAiBloc bloc;

  setUp(() {
    bloc = MockAiBloc();
    when(() => bloc.stream).thenAnswer((_) => const Stream.empty());
    addTearDown(() => bloc.close());
  });

  group('AiChatScaffold — loading states', () {
    testWidgets('shows indeterminate spinner when AiStatusInitial', (tester) async {
      when(() => bloc.state)
          .thenReturn(const AiState(status: AiStatusInitial()));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(find.text('Getting AI ready…'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows determinate bar and percentage when AiStatusInstalling', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(status: AiStatusInstalling(), downloadProgress: 45),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(find.text('Getting AI ready…'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.45, 0.001));
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows download subtitle when AiStatusInstalling', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(status: AiStatusInstalling()),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(
        find.text('Downloading model for the first time. This only happens once.'),
        findsOneWidget,
      );
    });

    testWidgets('does not show download subtitle when AiStatusInitial', (tester) async {
      when(() => bloc.state)
          .thenReturn(const AiState(status: AiStatusInitial()));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(
        find.text('Downloading model for the first time. This only happens once.'),
        findsNothing,
      );
    });
  });

  group('AiChatScaffold — error state', () {
    testWidgets('shows error message and retry button', (tester) async {
      when(() => bloc.state)
          .thenReturn(AiState(status: AiStatusError('Network error')));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('retry button dispatches AiInitEvent', (tester) async {
      when(() => bloc.state)
          .thenReturn(AiState(status: AiStatusError('fail')));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      await tester.tap(find.text('Retry'));
      verify(() => bloc.add(const AiInitEvent())).called(1);
    });
  });

  group('AiChatScaffold — loaded state', () {
    testWidgets('shows enabled input when loaded and not generating', (tester) async {
      when(() => bloc.state)
          .thenReturn(const AiState(status: AiStatusLoaded()));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isNot(false));
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('input is disabled when isGenerating', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(status: AiStatusLoaded(), isGenerating: true),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, false);
    });

    testWidgets('send button dispatches SendPromptEvent', (tester) async {
      when(() => bloc.state)
          .thenReturn(const AiState(status: AiStatusLoaded()));
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.tap(find.byIcon(Icons.send));
      verify(() => bloc.add(const SendPromptEvent('Hello AI'))).called(1);
    });

    testWidgets('send button is disabled when isGenerating', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(status: AiStatusLoaded(), isGenerating: true),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows user and AI messages', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(
          status: AiStatusLoaded(),
          messages: [
            ChatMessage(text: 'Hello', isUser: true),
            ChatMessage(text: 'Hi there', isUser: false),
          ],
        ),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there'), findsOneWidget);
    });

    testWidgets('AI streaming message shows trailing ellipsis', (tester) async {
      when(() => bloc.state).thenReturn(
        const AiState(
          status: AiStatusLoaded(),
          isGenerating: true,
          messages: [
            ChatMessage(text: 'Thinking', isUser: false, isStreaming: true),
          ],
        ),
      );
      await tester.pumpWidget(_wrap(const AiChatScaffold(title: 'Test'), bloc));
      expect(find.text('Thinking…'), findsOneWidget);
    });

    testWidgets('AppBar shows the provided title', (tester) async {
      when(() => bloc.state)
          .thenReturn(const AiState(status: AiStatusLoaded()));
      await tester.pumpWidget(
          _wrap(const AiChatScaffold(title: 'Build Workout'), bloc));
      expect(find.text('Build Workout'), findsOneWidget);
    });
  });
}
