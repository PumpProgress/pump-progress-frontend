import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/config/constants/fonts.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/start_exercises/bloc/start_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/start_exercises/view/modal_bottom_sheet_add_to_workout.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final startExercisesBloc = context.read<StartExercisesBloc>();
    final exercise = startExercisesBloc.state.itemsFiltered[index];

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      color: PPColors.amethyst500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
          '/exercises',
          arguments: ExercisesPageArguments(
              exerciseId: exercise.id, exerciseName: exercise.name),
        ),
        onLongPress: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) => ModalBottomSheetAddToWorkout(
                  exerciseId: exercise.id,
                )),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
        title: Text(
          exercise.name,
          style: TextTheme.of(context).titleMedium?.copyWith(
                color: PPColors.amethyst100,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Wrap(
            spacing: 8.0,
            children: exercise.muscles
                .map(
                  (muscle) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: Text(
                      muscle.toUpperCase(),
                      style: TextTheme.of(context).labelSmall?.copyWith(
                            color: PPColors.coral300,
                          ),
                    ),
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
            color: PPColors.coral300,
          ),
          onPressed: () => context
              .read<StartExercisesBloc>()
              .add(HandleUpdateFavoriteExerciseEvent(index)),
        ),
      ),
    );
  }
}

class PPFontStyles {}
