import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/repositories/models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

class WorkoutSessionItemWidget extends StatelessWidget {
  const WorkoutSessionItemWidget({super.key, required this.workoutSession});

  final WorkoutSession workoutSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WorkoutSessionItemWidgetHeader(
            workoutSession: workoutSession,
          ),
          Divider(color: Theme.of(context).colorScheme.primary),
          WorkoutSessionItemWidgetBody(
            workoutSession: workoutSession,
          )
        ],
      ),
    );
  }
}

class WorkoutSessionItemWidgetHeader extends StatelessWidget {
  const WorkoutSessionItemWidgetHeader(
      {super.key, required this.workoutSession});

  final WorkoutSession workoutSession;

  @override
  Widget build(BuildContext context) {
    final dateStr = formatWorkoutDate(workoutSession.createdAt);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(workoutSession.user.name), Text(dateStr)],
      ),
    );
  }
}

class WorkoutSessionItemWidgetBody extends StatelessWidget {
  const WorkoutSessionItemWidgetBody({
    super.key,
    required this.workoutSession,
  });

  final WorkoutSession workoutSession;

  @override
  Widget build(BuildContext context) {
    final exercisesSets = workoutSession.exercises.map(
      (exercise) {
        final sets =
            exercise.sets.map((s) => Text("${s.repetitions}x ${s.weight}kg,"));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${exercise.name} - ${exercise.sets.length} sets",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            Wrap(
              spacing: 8, // Optional: adds spacing between items
              runSpacing: 4, // Optional: spacing between lines when wrapping
              children: sets.toList(),
            ),
          ],
        );
      },
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Text("Exercises"),
          ...exercisesSets
        ],
      ),
    );
  }
}

String formatWorkoutDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays <= 7) {
    return timeago.format(date);
  }

  final isSameYear = date.year == now.year;
  final format = isSameYear ? 'EEE, MMM d' : 'EEE, MMM d, y';
  return DateFormat(format).format(date);
}
