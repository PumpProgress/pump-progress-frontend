import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final homeExercisesBloc = context.read<HomeExercisesBloc>();
    final exercise = homeExercisesBloc.state.itemsFiltered[index];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          '/exercises',
          arguments: ExercisesPageArguments(exercise.id),
        ),
        title: Text(
          exercise.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 4.0,
            runSpacing: -8.0,
            children: exercise.muscles
                .map(
                  (muscle) => Chip(
                    label: Text(
                      muscle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade600,
                  ),
                )
                .toList(),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            exercise.isFavorite
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            color: exercise.isFavorite ? Colors.yellow.shade700 : Colors.grey,
          ),
          onPressed: () => context
              .read<HomeExercisesBloc>()
              .add(HandleUpdateFavoriteExerciseEvent(index)),
        ),
      ),
    );
  }
}
