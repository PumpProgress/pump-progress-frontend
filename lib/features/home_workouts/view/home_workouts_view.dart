import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/home_workouts/bloc/home_workouts_bloc.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workout_floating_button.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workout_item.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class HomeWorkouts extends StatelessWidget {
  const HomeWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeWorkoutsBloc, HomeWorkoutsState>(
        builder: (context, state) {
      void saveWorkout(String name) {
        try {
          final workoutBloc = context.read<HomeWorkoutsBloc>();
          workoutBloc.add(
            AddWorkoutHomeWorkoutsEvent(name: name),
          );
        } catch (e) {
          print(e);
        }
      }

      print(state.toString());
      if (state.status == HomeWorkoutsStatus.loading) {
        return const LoadingPage();
      }
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: state.workouts.length,
                itemBuilder: (context, index) {
                  return WorkoutWidgetItem(index: index);
                }),
          ),
          HomeWorkoutFloatingActionButton(
            saveWorkout: saveWorkout,
          )
        ],
      );
    });
  }
}
