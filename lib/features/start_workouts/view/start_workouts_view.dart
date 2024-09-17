import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/app.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/features/start_workouts/view/start_workout_item.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class StartWorkouts extends StatefulWidget {
  const StartWorkouts({super.key});

  @override
  State<StartWorkouts> createState() => _StartWorkoutsState();
}

class _StartWorkoutsState extends State<StartWorkouts> with RouteAware {
  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context) {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);

    return BlocConsumer<WorkoutsBloc, WorkoutsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == WorkoutsStatus.loading) {
            return const LoadingPage();
          }
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: state.workouts.length + 1,
                      itemBuilder: (context, index) {
                        return WorkoutWidgetItem(index: index);
                      }),
                ),
                // StartWorkoutFloatingActionButton()
              ],
            ),
          );
        });
  }
}
