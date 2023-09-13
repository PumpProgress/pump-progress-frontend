import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/app.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workout_floating_button.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workout_item.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class HomeWorkouts extends StatefulWidget {
  const HomeWorkouts({super.key});

  @override
  State<HomeWorkouts> createState() => _HomeWorkoutsState();
}

class _HomeWorkoutsState extends State<HomeWorkouts> with RouteAware {
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
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: state.workouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutWidgetItem(index: index);
                    }),
              ),
              HomeWorkoutFloatingActionButton()
            ],
          );
        });
  }
}
