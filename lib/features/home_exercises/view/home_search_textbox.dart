import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/constants/categories.dart';
import 'package:pump_progress_frontend/config/constants/muscles.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';

class SearchBarWithFilter extends StatelessWidget {
  SearchBarWithFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final homeExerciseBloc = context.read<HomeExercisesBloc>();
    final state = homeExerciseBloc.state;
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            homeExerciseBloc.add(
              UpdatedSearchExerciseListEvent(
                value,
                state.selectedCategories,
                state.selectedMuscles,
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
              value: state.selectedMuscles.isNotEmpty
                  ? state.selectedMuscles[0]
                  : Muscles.chest.toString(),
              hint: const Text('Select Muscle'),
              onChanged: (value) {
                print(value);
                homeExerciseBloc.add(
                  UpdatedSearchExerciseListEvent(
                    state.searchValue,
                    state.selectedCategories,
                    value != null ? [value] : null,
                  ),
                );
              },
              items: Muscles.values.map((muscle) {
                print(muscle);
                final muscleString = muscle.toString();
                return DropdownMenuItem<String>(
                  value: muscleString,
                  child: Text(muscleString),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: state.selectedCategories.isNotEmpty
                  ? state.selectedCategories[0]
                  : Categories.cables.toString(),
              hint: const Text('Select Category'),
              onChanged: (value) {
                print(value);
                homeExerciseBloc.add(
                  UpdatedSearchExerciseListEvent(
                    state.searchValue,
                    value != null ? [value] : null,
                    state.selectedMuscles,
                  ),
                );
              },
              items: Categories.values.map((category) {
                final categoryString = category.toString();
                return DropdownMenuItem<String>(
                  value: categoryString,
                  child: Text(categoryString),
                );
              }).toList(),
            ),
          ],
        ),
        // const SizedBox(height: 10),
        // Text(
        //   'Search Text: $state.searchText\nSelected Muscle: $state.selectedMuscle\nSelected Category: $state.selectedCategory',
        //   style: const TextStyle(fontSize: 16),
        // ),
        // Add code here to display the filtered results based on the search text, selected muscle, and selected category.
      ],
    );
  }
}
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';

class SearchBarWithFilter extends StatefulWidget {
  @override
  _SearchBarWithFilterState createState() => _SearchBarWithFilterState();
}

class _SearchBarWithFilterState extends State<SearchBarWithFilter> {
  String _searchText = '';
  List<String> _selectedMuscles = [];
  List<String> _selectedCategories = [];

  List<String> _muscles = [
    'Muscle 1',
    'Muscle 2',
    'Muscle 3',
  ];

  List<String> _categories = [
    'Category 1',
    'Category 2',
    'Category 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButtonFormField<List<String>>(
              value: _selectedMuscles,
              hint: Text('Select Muscles'),
              onChanged: (value) {
                setState(() {
                  _selectedMuscles = value ?? [];
                });
              },
              items: _muscles.map((muscle) {
                return DropdownMenuItem<List<String>>(
                  value: _selectedMuscles.contains(muscle)
                      ? _selectedMuscles..remove(muscle)
                      : _selectedMuscles..add(muscle),
                  child: CheckboxListTile(
                    title: Text(muscle),
                    value: _selectedMuscles.contains(muscle),
                    onChanged: (_) {},
                  ),
                );
              }).toList(),
            ),
            DropdownButtonFormField<List<String>>(
              value: _selectedCategories,
              hint: Text('Select Categories'),
              onChanged: (value) {
                setState(() {
                  _selectedCategories = value ?? [];
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem<List<String>>(
                  value: _selectedCategories.contains(category)
                      ? _selectedCategories..remove(category)
                      : _selectedCategories..add(category),
                  child: CheckboxListTile(
                    title: Text(category),
                    value: _selectedCategories.contains(category),
                    onChanged: (_) {},
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          'Search Text: $_searchText\nSelected Muscles: ${_selectedMuscles.join(", ")}\nSelected Categories: ${_selectedCategories.join(", ")}',
          style: TextStyle(fontSize: 16.0),
        ),
        // Add code here to display the filtered results based on the search text, selected muscles, and selected categories.
      ],
    );
  }
}
