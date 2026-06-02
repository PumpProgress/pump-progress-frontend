import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/exercise/blocs/bloc_exercise_search/exercise_search_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';

class MockRepositoryExercises extends Mock implements RepositoryExercises {}

void main() {
  late MockRepositoryExercises repo;

  const benchPress = Exercise(
    id: 1,
    code: 'barbell_bench_press',
    name: 'Barbell Bench Press',
    category: 'Chest',
    muscles: ['Chest'],
    equipment: 'Barbell',
  );
  const squat = Exercise(
    id: 2,
    code: 'barbell_back_squat',
    name: 'Barbell Back Squat',
    category: 'Legs',
    muscles: ['Quadriceps'],
    equipment: 'Barbell',
  );

  setUp(() {
    repo = MockRepositoryExercises();
    when(() => repo.getAllExercises())
        .thenAnswer((_) async => [benchPress, squat]);
  });

  blocTest<ExerciseSearchBloc, ExerciseSearchState>(
    'returns fuzzy matches for a term',
    build: () => ExerciseSearchBloc(repositoryExercises: repo),
    act: (bloc) => bloc.add(const UpdateSearchTermEvent('bench')),
    verify: (bloc) {
      expect(bloc.state.status, isA<ExerciseSearchSuccess>());
      expect(bloc.state.exercises.first, benchPress);
    },
  );

  blocTest<ExerciseSearchBloc, ExerciseSearchState>(
    'empty term emits no results',
    build: () => ExerciseSearchBloc(repositoryExercises: repo),
    act: (bloc) => bloc.add(const UpdateSearchTermEvent('')),
    verify: (bloc) {
      expect(bloc.state.exercises, isEmpty);
    },
  );

  blocTest<ExerciseSearchBloc, ExerciseSearchState>(
    'loads the catalog only once across multiple searches',
    build: () => ExerciseSearchBloc(repositoryExercises: repo),
    act: (bloc) async {
      bloc.add(const UpdateSearchTermEvent('bench'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const UpdateSearchTermEvent('squat'));
    },
    verify: (bloc) {
      verify(() => repo.getAllExercises()).called(1);
    },
  );
}
