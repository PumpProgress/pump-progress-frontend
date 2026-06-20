import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/exercise/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/exercise/domain/domain.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';

class WorkoutAddExerciseItemButton extends StatelessWidget {
  const WorkoutAddExerciseItemButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final workoutDetailBloc = context.read<WorkoutDetailBloc>();

    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => ExerciseSearchBloc(
              repositoryExercises: context.read(),
            ),
            child: AddExerciseToWorkoutModal(
              onExerciseSelected: (exercise) {
                workoutDetailBloc.add(
                  AddExerciseWorkoutDetailEvent(exerciseId: exercise.id),
                );
              },
            ),
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
    required this.onExerciseSelected,
  });

  final Function(Exercise exercise) onExerciseSelected;

  @override
  State<AddExerciseToWorkoutModal> createState() =>
      _AddExerciseToWorkoutModalState();
}

class _AddExerciseToWorkoutModalState extends State<AddExerciseToWorkoutModal> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExerciseSearchBloc, ExerciseSearchState>(
      listener: (context, state) {},
      builder: (context, state) {
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
                  onChanged: (value) => context
                      .read<ExerciseSearchBloc>()
                      .add(UpdateSearchTermEvent(value)),
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
                    itemCount: state.exercises.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          widget.onExerciseSelected(state.exercises[index]);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Text(state.exercises[index].name),
                        )),
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
