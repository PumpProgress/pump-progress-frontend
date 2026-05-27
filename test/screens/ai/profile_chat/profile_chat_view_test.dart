import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/screens/ai/profile_chat/view/profile_chat_view.dart';

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

  testWidgets('shows loading UI when status is GemmaModelStatusInstalling',
      (tester) async {
    when(() => modelBloc.state).thenReturn(
      const GemmaModelState(status: GemmaModelStatusInstalling()),
    );
    await tester.pumpWidget(_wrap(
      const ProfileChatView(),
      modelBloc: modelBloc,
      chatBloc: chatBloc,
    ));
    expect(find.text('Getting AI ready…'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shows loading UI when status is GemmaModelStatusInitial',
      (tester) async {
    when(() => modelBloc.state).thenReturn(
      const GemmaModelState(status: GemmaModelStatusInitial()),
    );
    await tester.pumpWidget(_wrap(
      const ProfileChatView(),
      modelBloc: modelBloc,
      chatBloc: chatBloc,
    ));
    expect(find.text('Getting AI ready…'), findsOneWidget);
    expect(
      find.text('Downloading model for the first time. This only happens once.'),
      findsNothing,
    );
  });

  testWidgets('shows chat input when model is ready and chat is ready',
      (tester) async {
    when(() => modelBloc.state).thenReturn(
      const GemmaModelState(status: GemmaModelStatusReady()),
    );
    when(() => chatBloc.state).thenReturn(const ChatState(isReady: true));
    await tester.pumpWidget(_wrap(
      const ProfileChatView(),
      modelBloc: modelBloc,
      chatBloc: chatBloc,
    ));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows error message and retry button on GemmaModelStatusError',
      (tester) async {
    when(() => modelBloc.state).thenReturn(
      GemmaModelState(status: GemmaModelStatusError('Network error')),
    );
    await tester.pumpWidget(_wrap(
      const ProfileChatView(),
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
      const ProfileChatView(),
      modelBloc: modelBloc,
      chatBloc: chatBloc,
    ));
    await tester.tap(find.text('Retry'));
    verify(() => modelBloc.add(const GemmaModelInitEvent())).called(1);
  });
}
