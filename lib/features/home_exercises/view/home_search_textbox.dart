import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';

final musclesList = [
  'Biceps',
  'Forearms',
  'Shoulders',
  'Triceps',
  'Quads',
  'Glutes',
  'Lats',
  'Mid back',
  'Lower back',
  'Hamstrings',
  'Chest',
  'Abdominals',
  'Obliques',
  'Traps',
  'Calves',
];

final categoriesList = [
  'Barbell',
  'Dumbbells',
  'Kettlebells',
  'Stretches',
  'Cables',
  'Band',
  'Plate',
  'TRX',
  'Bodyweight',
  'Yoga',
  'Machine',
  'MedicineBall',
];

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter({super.key});

  @override
  Widget build(BuildContext context) {
    musclesList.sort();
    categoriesList.sort();
    final homeExerciseBloc = context.read<HomeExercisesBloc>();
    return BlocBuilder<HomeExercisesBloc, HomeExercisesState>(
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              onChanged: (value) {
                homeExerciseBloc.add(
                  UpdatedSearchExerciseListEvent(
                    searchValue: value,
                    selectedCategories: state.selectedCategories,
                    selectedMuscles: state.selectedMuscles,
                  ),
                );
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: null,
                  hint: const Text('Select Muscle'),
                  onChanged: (value) {
                    final selectedMuscles = state.selectedMuscles.toList();
                    state.selectedMuscles.contains(value)
                        ? selectedMuscles.remove(value)
                        : selectedMuscles.add(value!);

                    homeExerciseBloc.add(
                      UpdatedSearchExerciseListEvent(
                        searchValue: state.searchValue,
                        selectedCategories: state.selectedCategories,
                        selectedMuscles: selectedMuscles,
                      ),
                    );
                  },
                  items: musclesList.map((muscle) {
                    final muscleString = muscle.toString();
                    return DropdownMenuItem<String>(
                      value: muscleString,
                      child: Row(
                        children: [
                          Icon(
                            state.selectedMuscles.contains(muscle)
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                          ),
                          Text(muscleString),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: null,
                  hint: const Text('Select Category'),
                  onChanged: (value) {
                    final selectedCategories =
                        state.selectedCategories.toList();
                    state.selectedCategories.contains(value)
                        ? selectedCategories.remove(value)
                        : selectedCategories.add(value!);
                    homeExerciseBloc.add(
                      UpdatedSearchExerciseListEvent(
                        searchValue: state.searchValue,
                        selectedCategories: state.selectedCategories,
                        selectedMuscles: state.selectedMuscles,
                      ),
                    );
                  },
                  items: categoriesList.map((category) {
                    final categoryString = category.toString();
                    return DropdownMenuItem<String>(
                      value: categoryString,
                      child: Row(
                        children: [
                          Icon(
                            state.selectedCategories.contains(categoryString)
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                          ),
                          Text(categoryString),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------

