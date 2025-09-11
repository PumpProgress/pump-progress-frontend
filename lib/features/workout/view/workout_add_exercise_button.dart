import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_exercises/exercises_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class WorkoutAddExerciseItemButton extends StatelessWidget {
  const WorkoutAddExerciseItemButton({
    super.key,
    required this.addExerciseToWorkout,
  });

  final void Function(String exerciseId) addExerciseToWorkout;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AddExerciseToWorkoutModal(
            addExerciseToWorkout: addExerciseToWorkout,
          );
        },
      ),
      child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: PPColors.amethyst300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: PPColors.neutral500,
              border: Border.all(
                color: PPColors.amethyst300,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: PPColors.amethyst300,
              ),
            ),
          )),
    );
  }
}

class AddExerciseToWorkoutModal extends StatefulWidget {
  const AddExerciseToWorkoutModal({
    super.key,
    required this.addExerciseToWorkout,
  });

  final void Function(String exerciseId) addExerciseToWorkout;

  @override
  State<AddExerciseToWorkoutModal> createState() =>
      _AddExerciseToWorkoutModalState();
}

class _AddExerciseToWorkoutModalState extends State<AddExerciseToWorkoutModal> {
  String exerciseName = '';

  void _onClickHandler(Exercise exercise) {
    try {
      widget.addExerciseToWorkout(exercise.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = context.select(
      (ExercisesBloc bloc) => bloc.state.exercises,
    );

    var exercisesFiltered = exercises
        .where((exercise) =>
            exercise.name.toLowerCase().contains(exerciseName.toLowerCase()))
        .toList();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => setState(() {
                exerciseName = value;
              }),
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                labelText: 'Exercise name...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: exercisesFiltered.length,
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _onClickHandler(exercisesFiltered[index]);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Text(exercisesFiltered[index].name),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
