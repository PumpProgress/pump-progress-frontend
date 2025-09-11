import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/features/workout/bloc/workout_bloc.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_add_exercise_button.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_exercise_list.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({
    super.key,
    required this.workout,
  });

  final Workout workout;

  static const routeName = '/workouts';

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WorkoutBloc>()
      ..add(InitWorkoutEvent(workout: widget.workout))
      ..add(const LoadExercisesWorkoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
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
            title: Text(
              widget.workout.name,
              // style: PPFontStyles.h5.copyWith(color: PPColors.amethyst100),
            ),
          ),
          // floatingActionButton: WorkoutFloatingActionButton(
          //     addExerciseToWorkout: addExerciseToWorkout, // todo
          // ),
          body: Container(
              padding: const EdgeInsets.all(16.0),
              child: switch (state.status) {
                WorkoutPageStatusLoading() => const LoadingPage(),
                WorkoutPageStatusError() => const Center(
                    child: Text("Error loading data"),
                  ),
                _ => Column(
                    children: [
                      WorkoutAddExerciseItemButton(
                        addExerciseToWorkout: addExerciseToWorkout,
                      ),
                      Expanded(
                        child: state.workout.exercises.isEmpty
                            ? Text("No exercises added yet.")
                            : ExerciseList(
                                addExerciseToWorkout: addExerciseToWorkout,
                                exercisesAtWorkout: state.workout.exercises,
                              ),
                      )
                    ],
                  ),
              }),
        );
      },
    );
  }
}
