import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/features/workout/bloc/workout_bloc.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_floating_button.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_list.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({
    super.key,
    required this.workout,
  });

  final Workout workout;

  static const routeName = '/workouts';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>())
        ..add(InitWorkoutEvent(workout: workout))
        ..add(const LoadExercisesWorkoutEvent()),
      child: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          void addExerciseToWorkout(String exerciseId) {
            try {
              final workoutBloc = context.read<WorkoutBloc>();
              workoutBloc.add(
                AddExerciseWorkoutEvent(exerciseId: exerciseId),
              );
            } catch (e) {
              print(e);
            }
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(workout.name),
            ),
            floatingActionButton: WorkoutFloatingActionButton(
                addExerciseToWorkout: addExerciseToWorkout,
                exercises: state.exercises),
            body: Container(
              child: (state.status == WorkoutPageStatus.loading)
                  ? const LoadingPage()
                  : ExerciseList(
                      exercises: state.workoutExercises,
                    ),
            ),
          );
        },
      ),
    );
  }
}
