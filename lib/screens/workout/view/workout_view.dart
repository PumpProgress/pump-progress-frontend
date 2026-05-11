import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';
import 'package:pump_progress_frontend/screens/workout/view/widgets/workout_add_exercise_button.dart';
import 'package:pump_progress_frontend/screens/workout/view/widgets/workout_exercise_list.dart';

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
  void _showRenameSheet(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<WorkoutDetailBloc>().add(
                        RenameWorkoutDetailEvent(name: controller.text),
                      );
                  Navigator.of(sheetContext).pop();
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String workoutName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete $workoutName?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<WorkoutDetailBloc>()
                    .add(DeleteWorkoutDetailEvent());
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutDetailBloc, WorkoutDetailState>(
      listener: (context, state) {
        if (state.status is WorkoutDetailStatusUpdated) {
          context.read<WorkoutBloc>().add(
                FetchWorkoutEvent(userId: state.workout.userId),
              );
        }
        if (state.status is WorkoutDetailStatusDeleted) {
          context.read<WorkoutBloc>().add(
                FetchWorkoutEvent(userId: widget.workout.userId),
              );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final workoutName = state.workout.name.isNotEmpty
            ? state.workout.name
            : widget.workout.name;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    workoutName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _showRenameSheet(context, workoutName),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showDeleteDialog(context, workoutName),
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: switch (state.status) {
              WorkoutDetailStatusLoading() => const LoadingPage(),
              WorkoutDetailStatusError() => const Center(
                  child: Text('Error loading data'),
                ),
              _ => Column(
                  children: [
                    WorkoutAddExerciseItemButton(),
                    Expanded(
                      child: state.workout.exercises.isEmpty
                          ? const Text('No exercises added yet.')
                          : ExerciseList(
                              exercisesAtWorkout: state.workout.exercises,
                            ),
                    ),
                  ],
                ),
            },
          ),
        );
      },
    );
  }
}
