import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/view/exercise_page.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/repositories/models/exercise.dart';

class HomeExerciseItem extends StatelessWidget {
  const HomeExerciseItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeExercisesBloc, HomeExercisesState>(
      builder: (context, state) {
        final exercise = state.itemsFiltered[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              ExercisePage.routeName,
              arguments: ExercisesPageArguments(exercise.id),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.name),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: exercise.muscles
                            .map<Widget>(
                              (m) => MuscleChip(
                                muscle: m,
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
                ),
                FavIndicator(
                  exercise: state.itemsFiltered[index],
                  index: index,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavIndicator extends StatelessWidget {
  const FavIndicator({super.key, required this.exercise, required this.index});
  final Exercise exercise;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<HomeExercisesBloc>()
          .add(HandleUpdateFavoriteExerciseEvent(index)),
      child: exercise.isFavorite
          ? const Icon(Icons.star_rounded)
          : const Icon(Icons.star_outline_rounded),
    );
  }
}

class MuscleChip extends StatelessWidget {
  const MuscleChip({super.key, required this.muscle});
  final String muscle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: Text(muscle),
    );
  }
}
