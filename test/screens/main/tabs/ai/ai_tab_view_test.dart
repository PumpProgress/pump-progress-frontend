import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/screens/main/tabs/ai/view/ai_tab_view.dart';

void main() {
  testWidgets('renders all three mode cards', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AiTabView())),
    );
    expect(find.text('Complete Profile'), findsOneWidget);
    expect(find.text('Build Workout'), findsOneWidget);
    expect(find.text('Coming Soon'), findsOneWidget);
  });

  testWidgets('tapping Complete Profile pushes /ai/profile-chat', (tester) async {
    final pushedRoutes = <String?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: AiTabView()),
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name);
          return MaterialPageRoute(builder: (_) => const Scaffold());
        },
      ),
    );
    await tester.tap(find.text('Complete Profile'));
    await tester.pumpAndSettle();
    expect(pushedRoutes, contains('/ai/profile-chat'));
  });

  testWidgets('tapping Build Workout pushes /ai/workout-builder', (tester) async {
    final pushedRoutes = <String?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: AiTabView()),
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name);
          return MaterialPageRoute(builder: (_) => const Scaffold());
        },
      ),
    );
    await tester.tap(find.text('Build Workout'));
    await tester.pumpAndSettle();
    expect(pushedRoutes, contains('/ai/workout-builder'));
  });

  testWidgets('Coming Soon card is not tappable', (tester) async {
    final pushedRoutes = <String?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: AiTabView()),
        onGenerateRoute: (settings) {
          pushedRoutes.add(settings.name);
          return MaterialPageRoute(builder: (_) => const Scaffold());
        },
      ),
    );
    await tester.tap(find.text('Coming Soon'));
    await tester.pumpAndSettle();
    expect(pushedRoutes, isEmpty);
  });
}
