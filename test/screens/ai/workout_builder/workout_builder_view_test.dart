import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/screens/ai/workout_builder/view/workout_builder_view.dart';

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

  testWidgets('shows loading UI when status is AiStatusInstalling',
      (tester) async {
    when(() => bloc.state)
        .thenReturn(const AiState(status: AiStatusInstalling()));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    expect(find.text('Getting AI ready…'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('shows loading UI when status is AiStatusInitial — no download subtitle',
      (tester) async {
    when(() => bloc.state)
        .thenReturn(const AiState(status: AiStatusInitial()));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    expect(find.text('Getting AI ready…'), findsOneWidget);
    expect(
      find.text('Downloading model for the first time. This only happens once.'),
      findsNothing,
    );
  });

  testWidgets('shows chat input when status is AiStatusLoaded', (tester) async {
    when(() => bloc.state)
        .thenReturn(const AiState(status: AiStatusLoaded()));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows error and retry on AiStatusError', (tester) async {
    when(() => bloc.state)
        .thenReturn(AiState(status: AiStatusError('fail')));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('AppBar title is Build Workout', (tester) async {
    when(() => bloc.state)
        .thenReturn(const AiState(status: AiStatusLoaded()));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    expect(find.text('Build Workout'), findsOneWidget);
  });

  testWidgets('retry button dispatches AiInitEvent', (tester) async {
    when(() => bloc.state)
        .thenReturn(AiState(status: AiStatusError('fail')));
    await tester.pumpWidget(_wrap(const WorkoutBuilderView(), bloc));
    await tester.tap(find.text('Retry'));
    verify(() => bloc.add(const AiInitEvent())).called(1);
  });
}
