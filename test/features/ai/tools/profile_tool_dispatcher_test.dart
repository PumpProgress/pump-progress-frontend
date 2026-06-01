import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/ai/tools/profile_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';

class MockUserSessionBloc extends Mock implements UserSessionBloc {}

void main() {
  late MockUserSessionBloc bloc;

  void stubUser(User user) {
    when(() => bloc.state).thenReturn(UserSessionState(user: user));
  }

  setUpAll(() {
    registerFallbackValue(const UserSessionUpdateProfileEvent());
  });

  setUp(() {
    bloc = MockUserSessionBloc();
    stubUser(User.unknown);
  });

  Future<ProfileToolDispatcher> buildInitialized() async {
    final dispatcher = ProfileToolDispatcher(userSessionBloc: bloc);
    await dispatcher.init();
    return dispatcher;
  }

  group('ProfileToolDispatcher.tools', () {
    test('exposes only save_user_information', () async {
      final dispatcher = await buildInitialized();
      final names = dispatcher.tools.map((t) => t.name).toList();
      expect(names, ['save_user_information']);
    });
  });

  group('nextMissingField', () {
    test('returns name first for an empty profile', () async {
      final dispatcher = await buildInitialized();
      expect(dispatcher.nextMissingField, 'name');
    });

    test('skips already-saved fields seeded from the session', () async {
      stubUser(const User(
        id: '1',
        name: 'Ada',
        email: 'a@b.c',
        favoriteExercises: [],
      ));
      final dispatcher = await buildInitialized();
      expect(dispatcher.nextMissingField, 'age');
    });

    test('returns all_fields_collected when complete', () async {
      stubUser(const User(
        id: '1',
        name: 'Ada',
        email: 'a@b.c',
        favoriteExercises: [],
        age: 30,
        gender: 'female',
        fitnessLevel: 'beginner',
        primaryGoal: 'strength',
        trainingDaysPerWeek: 3,
      ));
      final dispatcher = await buildInitialized();
      expect(dispatcher.nextMissingField, 'all_fields_collected');
    });
  });

  group('save_user_information', () {
    test('dispatches UserSessionUpdateProfileEvent and advances missing field',
        () async {
      stubUser(const User(
        id: '1',
        name: 'Ada',
        email: 'a@b.c',
        favoriteExercises: [],
      ));
      final dispatcher = await buildInitialized();

      final resolved = dispatcher.resolve(
        FunctionCallResponse(name: 'save_user_information', args: {'age': 30}),
      );
      final result = await resolved.execute();

      final captured = verify(() => bloc.add(captureAny())).captured.last;
      expect(captured, isA<UserSessionUpdateProfileEvent>());
      expect((captured as UserSessionUpdateProfileEvent).age, 30);
      // name + age now known, next missing is gender.
      expect(result['missing_field'], 'gender');
    });

    test('returns a display_message summary once the profile is complete',
        () async {
      stubUser(const User(
        id: '1',
        name: 'Ada',
        email: 'a@b.c',
        favoriteExercises: [],
        age: 30,
        gender: 'Male',
        fitnessLevel: 'Beginner',
        primaryGoal: 'Gain strength',
      ));
      final dispatcher = await buildInitialized();

      final resolved = dispatcher.resolve(
        FunctionCallResponse(
          name: 'save_user_information',
          args: {'training_days_per_week': 3},
        ),
      );
      final result = await resolved.execute();

      expect(result['missing_field'], 'all_fields_collected');
      final summary = result['display_message'] as String;
      expect(summary, contains('Ada'));
      expect(summary, contains('Gain strength'));
      expect(summary, contains('3'));
    });

    test('omits display_message while fields are still missing', () async {
      final dispatcher = await buildInitialized();
      final resolved = dispatcher.resolve(
        FunctionCallResponse(name: 'save_user_information', args: {'age': 30}),
      );
      final result = await resolved.execute();
      expect(result.containsKey('display_message'), isFalse);
    });

    test('canonicalizes free-text enum fields onto profile options', () async {
      final dispatcher = await buildInitialized();

      final resolved = dispatcher.resolve(
        FunctionCallResponse(
          name: 'save_user_information',
          args: {'gender': 'male', 'fitness_level': 'BEGINNER'},
        ),
      );
      await resolved.execute();

      final captured = verify(() => bloc.add(captureAny())).captured.last
          as UserSessionUpdateProfileEvent;
      expect(captured.gender, 'Male');
      expect(captured.fitnessLevel, 'Beginner');
    });
  });
}
