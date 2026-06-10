import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/settings/repository/repository.dart';
import 'package:pump_progress_frontend/screens/settings/view/settings_view.dart';

class MockRepositorySettings extends Mock implements RepositorySettings {}

void main() {
  late MockRepositorySettings repo;

  setUp(() {
    repo = MockRepositorySettings();
    when(() => repo.appVersion()).thenAnswer((_) async => '4.1.0 (29)');
  });

  Widget wrap() => MaterialApp(
        home: RepositoryProvider<RepositorySettings>.value(
          value: repo,
          child: const SettingsView(),
        ),
      );

  testWidgets('renders the four settings tiles', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Rate app'), findsOneWidget);
    expect(find.text('Share app'), findsOneWidget);
    expect(find.text('Version'), findsOneWidget);
  });

  testWidgets('shows the resolved version string', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('4.1.0 (29)'), findsOneWidget);
  });

  testWidgets('tapping Privacy Policy calls the repository', (tester) async {
    when(() => repo.openPrivacyPolicy()).thenAnswer((_) async {});
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();

    verify(() => repo.openPrivacyPolicy()).called(1);
  });

  testWidgets('tapping Rate app calls rateApp', (tester) async {
    when(() => repo.rateApp()).thenAnswer((_) async {});
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rate app'));
    await tester.pump();

    verify(() => repo.rateApp()).called(1);
  });

  testWidgets('tapping Share app calls shareApp', (tester) async {
    when(() => repo.shareApp()).thenAnswer((_) async {});
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Share app'));
    await tester.pump();

    verify(() => repo.shareApp()).called(1);
  });
}
