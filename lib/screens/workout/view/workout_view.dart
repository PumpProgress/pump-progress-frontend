import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
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

class _RenameSheet extends StatefulWidget {
  const _RenameSheet({required this.currentName, required this.onSave});

  final String currentName;
  final void Function(String) onSave;

  @override
  State<_RenameSheet> createState() => _RenameSheetState();
}

class _RenameSheetState extends State<_RenameSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
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
              if (_controller.text.trim().isEmpty) return;
              widget.onSave(_controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _WorkoutViewState extends State<WorkoutView> {
  void _showRenameSheet(BuildContext context, String currentName) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _RenameSheet(
        currentName: currentName,
        onSave: (name) {
          context
              .read<WorkoutDetailBloc>()
              .add(RenameWorkoutDetailEvent(name: name));
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String workoutName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete $workoutName?',
              style: TextTheme.of(context)
                  .titleMedium
                  ?.copyWith(color: PPColors.coral400)),
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
