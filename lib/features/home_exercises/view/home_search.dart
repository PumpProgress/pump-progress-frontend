import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercise_dropdown.dart';

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

class HomeExercisesSearchWidget extends StatelessWidget {
  const HomeExercisesSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    musclesList.sort();
    categoriesList.sort();
    final homeExerciseBloc = context.read<HomeExercisesBloc>();
    return BlocBuilder<HomeExercisesBloc, HomeExercisesState>(
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
                        homeExerciseBloc.add(
                          UpdatedSearchExerciseListEvent(
                            searchValue: value,
                            selectedCategories: state.selectedCategories,
                            selectedMuscles: state.selectedMuscles,
                          ),
                        );
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
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
                      homeExerciseBloc.add(
                        const HandleToggleFiltersEvent(),
                      );
                    },
                    color: PumpProgressColors.coral,
                  ),
                ],
              ),
            ),
            !state.showFilters ? Container() : SizedBox(height: 10),
            !state.showFilters
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeExerciseDropdownWidget(
                        items: musclesList,
                        hint: '${state.selectedMuscles.length} Muscles',
                        selectedItems: state.selectedMuscles,
                        onChanged: (value) {
                          final selectedMuscles =
                              state.selectedMuscles.toList();
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
                      ),
                      HomeExerciseDropdownWidget(
                          items: categoriesList,
                          hint: '${state.selectedCategories.length} Categories',
                          selectedItems: state.selectedCategories,
                          onChanged: (value) {
                            final selectedCategories =
                                state.selectedCategories.toList();
                            state.selectedCategories.contains(value)
                                ? selectedCategories.remove(value)
                                : selectedCategories.add(value!);
                            homeExerciseBloc.add(
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
