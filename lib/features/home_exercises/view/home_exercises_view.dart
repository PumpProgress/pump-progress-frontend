import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercise_gpt.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercise_item.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class HomeExercises extends StatelessWidget {
  const HomeExercises({super.key});

  static TextEditingController searchEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeExercisesBloc, HomeExercisesState>(
      builder: (context, state) {
        if (state.status == HomeExerciseStatus.loading) {
          return const LoadingPage();
        }
        return Column(
          children: [
            TextField(
              onChanged: (value) => context
                  .read<HomeExercisesBloc>()
                  .add(UpdatedSearchExerciseListEvent(value)),
              controller: searchEditingController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.itemsFiltered.length,
                itemBuilder: (context, index) {
                  return ExerciseWidget(
                    index: index,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
