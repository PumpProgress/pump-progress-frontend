import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';
import 'package:pump_progress_frontend/screens/workout/view/workout_add_exercise_button.dart';
import 'package:pump_progress_frontend/screens/workout/view/workout_exercise_list.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({
    super.key,
    required this.workout,
  });

  final Workout workout;

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutDetailBloc, WorkoutDetailState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              widget.workout.name,
              // style: PPFontStyles.h5.copyWith(color: PPColors.amethyst100),
            ),
          ),
          body: Container(
              padding: const EdgeInsets.all(16.0),
              child: switch (state.status) {
                WorkoutDetailStatusLoading() => const LoadingPage(),
                WorkoutDetailStatusError() => const Center(
                    child: Text("Error loading data"),
                  ),
                _ => Column(
                    children: [
                      WorkoutAddExerciseItemButton(),
                      Expanded(
                        child: state.workout.exercises.isEmpty
                            ? Text("No exercises added yet.")
                            : ExerciseList(
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
