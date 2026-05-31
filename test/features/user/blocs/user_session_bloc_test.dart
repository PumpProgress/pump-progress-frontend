import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/domain/domain.dart';
import 'package:pump_progress_frontend/features/user/local/local.dart';
import 'package:pump_progress_frontend/features/user/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRepositoryUser extends Mock implements RepositoryUser {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('UserSessionUpdateProfileEvent', () {
    blocTest<UserSessionBloc, UserSessionState>(
      'updates user with profile fields and persists them',
      build: () => UserSessionBloc(repositoryUser: MockRepositoryUser()),
      seed: () => const UserSessionState(
        status: UserSessionStatusAuthenticated(),
        user: User(
          id: '1',
          name: 'xrok',
          email: 'sercar88@gmail.com',
          favoriteExercises: [],
        ),
      ),
      act: (bloc) => bloc.add(const UserSessionUpdateProfileEvent(
        age: 30,
        gender: 'Male',
        fitnessLevel: 'Intermediate',
        primaryGoal: 'Build muscle',
        availableDaysPerWeek: 4,
      )),
      verify: (bloc) async {
        expect(bloc.state.user.age, 30);
        expect(bloc.state.user.gender, 'Male');
        expect(bloc.state.user.fitnessLevel, 'Intermediate');
        expect(bloc.state.user.availableDaysPerWeek, 4);
        final saved = await LocalUserProfile().load();
        expect(saved!['primaryGoal'], 'Build muscle');
        expect(saved['fitnessLevel'], 'Intermediate');
      },
    );

    blocTest<UserSessionBloc, UserSessionState>(
      'clears a previously set field when the event carries null',
      build: () => UserSessionBloc(repositoryUser: MockRepositoryUser()),
      seed: () => const UserSessionState(
        status: UserSessionStatusAuthenticated(),
        user: User(
          id: '1',
          name: 'xrok',
          email: 'sercar88@gmail.com',
          favoriteExercises: [],
          age: 30,
          gender: 'Male',
        ),
      ),
      act: (bloc) => bloc.add(const UserSessionUpdateProfileEvent()),
      verify: (bloc) async {
        expect(bloc.state.user.age, isNull);
        expect(bloc.state.user.gender, isNull);
        final saved = await LocalUserProfile().load();
        expect(saved!['age'], isNull);
        expect(saved['gender'], isNull);
      },
    );
  });
}
