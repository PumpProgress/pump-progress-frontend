import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/start_exercises/bloc/start_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/start_exercises/view/start_exercise_dropdown.dart';

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

class StartExercisesSearchWidget extends StatelessWidget {
  const StartExercisesSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    musclesList.sort();
    categoriesList.sort();
    final startExerciseBloc = context.read<StartExercisesBloc>();
    return BlocBuilder<StartExercisesBloc, StartExercisesState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        startExerciseBloc.add(
                          UpdatedSearchExerciseListEvent(
                            searchValue: value,
                            selectedCategories: state.selectedCategories,
                            selectedMuscles: state.selectedMuscles,
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Search',
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        // labelStyle: PPFontStyles.paragraph.copyWith(
                        //   color: PPColors.neutral100,
                        // ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    // ignore: avoid_print
                    onPressed: () {
                      startExerciseBloc.add(
                        const HandleToggleFiltersEvent(),
                      );
                    },
                    color: PPColors.coral300,
                  ),
                ],
              ),
            ),
            !state.showFilters ? Container() : const SizedBox(height: 10),
            !state.showFilters
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StartExerciseDropdownWidget(
                        items: musclesList,
                        hint: '${state.selectedMuscles.length} Muscles',
                        selectedItems: state.selectedMuscles,
                        onChanged: (value) {
                          final selectedMuscles =
                              state.selectedMuscles.toList();
                          state.selectedMuscles.contains(value)
                              ? selectedMuscles.remove(value)
                              : selectedMuscles.add(value!);

                          startExerciseBloc.add(
                            UpdatedSearchExerciseListEvent(
                              searchValue: state.searchValue,
                              selectedCategories: state.selectedCategories,
                              selectedMuscles: selectedMuscles,
                            ),
                          );
                        },
                      ),
                      StartExerciseDropdownWidget(
                          items: categoriesList,
                          hint: '${state.selectedCategories.length} Categories',
                          selectedItems: state.selectedCategories,
                          onChanged: (value) {
                            final selectedCategories =
                                state.selectedCategories.toList();
                            state.selectedCategories.contains(value)
                                ? selectedCategories.remove(value)
                                : selectedCategories.add(value!);
                            startExerciseBloc.add(
                              UpdatedSearchExerciseListEvent(
                                searchValue: state.searchValue,
                                selectedCategories: selectedCategories,
                                selectedMuscles: state.selectedMuscles,
                              ),
                            );
                          }),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
