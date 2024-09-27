import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/start_exercises/bloc/start_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/start_exercises/view/start_exercise_item.dart';
import 'package:pump_progress_frontend/features/start_exercises/view/start_search.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class StartExercises extends StatelessWidget {
  const StartExercises({super.key});

  static TextEditingController searchEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartExercisesBloc, StartExercisesState>(
      builder: (context, state) {
        if (state.status == StartExerciseStatus.loading) {
          return const LoadingPage();
        }
        return Column(
          children: [
            const StartExercisesSearchWidget(),
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
