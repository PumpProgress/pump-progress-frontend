import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/blocs/bloc_workout/workout_bloc.dart';

class ModalBottomSheetAddToWorkout extends StatelessWidget {
  const ModalBottomSheetAddToWorkout({super.key, required this.exerciseId});

  final int exerciseId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        final workouts = state.workouts;
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("Select workout to +"),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      return ListTile(
                        onTap: () {
                          final user =
                              context.read<UserSessionBloc>().state.user;
                          context.read<WorkoutBloc>().add(
                              AddExerciseToWorkoutEvent(
                                  workoutId: workout.id,
                                  exerciseId: exerciseId,
                                  userId: user.id));
                          Navigator.of(context).pop();
                        },
                        title: Text(
                          workout.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
