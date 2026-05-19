import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pump_progress_frontend/features/workout/blocs/bloc_workout_detail/workout_detail_bloc.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository_workout.dart';

class MockRepositoryWorkout extends Mock implements RepositoryWorkout {}

void main() {
  late MockRepositoryWorkout mockRepo;

  const seedWorkout = Workout(
    id: 'w1',
    name: 'Push Day',
    userId: 'u1',
    exercises: [],
    exercisesCount: 0,
  );

  setUp(() {
    mockRepo = MockRepositoryWorkout();
  });

  group('RenameWorkoutDetailEvent', () {
    blocTest<WorkoutDetailBloc, WorkoutDetailState>(
      'emits [Loading, Updated, Success] with updated workout on success',
      setUp: () {
        when(() => mockRepo.updateWorkout(
              workoutId: 'w1',
              name: 'Leg Day',
            )).thenAnswer((_) async {});
        when(() => mockRepo.getWorkout(workoutId: 'w1')).thenAnswer(
          (_) async => const Workout(
            id: 'w1',
            name: 'Leg Day',
            userId: 'u1',
            exercises: [],
            exercisesCount: 0,
          ),
        );
      },
      build: () => WorkoutDetailBloc(repositoryWorkout: mockRepo),
      seed: () => WorkoutDetailState(
        status: WorkoutDetailStatusSuccess(),
        workout: seedWorkout,
      ),
      act: (bloc) => bloc.add(const RenameWorkoutDetailEvent(name: 'Leg Day')),
      expect: () => [
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusLoading>()),
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusUpdated>())
            .having((s) => s.workout.name, 'name', 'Push Day'),
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusSuccess>())
            .having((s) => s.workout.name, 'name', 'Leg Day'),
      ],
    );

    blocTest<WorkoutDetailBloc, WorkoutDetailState>(
      'emits [Loading, Error] when updateWorkout throws',
      setUp: () {
        when(() => mockRepo.updateWorkout(
              workoutId: any(named: 'workoutId'),
              name: any(named: 'name'),
            )).thenThrow(Exception('db error'));
      },
      build: () => WorkoutDetailBloc(repositoryWorkout: mockRepo),
      seed: () => WorkoutDetailState(
        status: WorkoutDetailStatusSuccess(),
        workout: seedWorkout,
      ),
      act: (bloc) => bloc.add(const RenameWorkoutDetailEvent(name: 'Leg Day')),
      expect: () => [
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusLoading>()),
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusError>()),
      ],
    );
  });

  group('DeleteWorkoutDetailEvent', () {
    blocTest<WorkoutDetailBloc, WorkoutDetailState>(
      'emits [Loading, Deleted] on success',
      setUp: () {
        when(() => mockRepo.deleteWorkout(workoutId: 'w1'))
            .thenAnswer((_) async {});
      },
      build: () => WorkoutDetailBloc(repositoryWorkout: mockRepo),
      seed: () => WorkoutDetailState(
        status: WorkoutDetailStatusSuccess(),
        workout: seedWorkout,
      ),
      act: (bloc) => bloc.add(DeleteWorkoutDetailEvent()),
      expect: () => [
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusLoading>()),
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusDeleted>()),
      ],
    );

    blocTest<WorkoutDetailBloc, WorkoutDetailState>(
      'emits [Loading, Error] when deleteWorkout throws',
      setUp: () {
        when(() => mockRepo.deleteWorkout(workoutId: any(named: 'workoutId')))
            .thenThrow(Exception('db error'));
      },
      build: () => WorkoutDetailBloc(repositoryWorkout: mockRepo),
      seed: () => WorkoutDetailState(
        status: WorkoutDetailStatusSuccess(),
        workout: seedWorkout,
      ),
      act: (bloc) => bloc.add(DeleteWorkoutDetailEvent()),
      expect: () => [
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusLoading>()),
        isA<WorkoutDetailState>()
            .having((s) => s.status, 'status', isA<WorkoutDetailStatusError>()),
      ],
    );
  });
}
