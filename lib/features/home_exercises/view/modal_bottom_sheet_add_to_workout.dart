import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';

class ModalBottomSheetAddToWorkout extends StatelessWidget {
  const ModalBottomSheetAddToWorkout({super.key, required this.addExercise});

  final void Function(String workoutId) addExercise;

  @override
  Widget build(BuildContext context) {
    final workoutsBloc = context.read<WorkoutsBloc>();
    final workouts = workoutsBloc.state.workouts;
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
                      addExercise(workout.id);
                      Navigator.pop(context);
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
  }
}
