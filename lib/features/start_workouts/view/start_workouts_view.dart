import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/features/start_workouts/view/start_workout_add_workout_button.dart';
import 'package:pump_progress_frontend/features/start_workouts/view/start_workout_item.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/utils/helpers/route_observer.dart';

class StartWorkouts extends StatefulWidget {
  const StartWorkouts({super.key});

  @override
  State<StartWorkouts> createState() => _StartWorkoutsState();
}

class _StartWorkoutsState extends State<StartWorkouts> with RouteAware {
  @override
  void didPopNext() {}

  @override
  void initState() {
    super.initState();
    final coreState = context.read<CoreBloc>().state;

    context
        .read<WorkoutsBloc>()
        .add(FetchWorkoutsEvent(userId: coreState.user.id));
  }

  @override
  Widget build(BuildContext context) {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);

    return BlocConsumer<WorkoutsBloc, WorkoutsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status is WorkoutsBlocStatusLoading) {
          return const LoadingPage();
        }
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StartWorkoutAddWorkoutButton(),
              Expanded(
                child: state.workouts.isEmpty
                    ? Text("No workouts created yet.")
                    : ListView.builder(
                        itemCount: state.workouts.length,
                        itemBuilder: (context, index) {
                          return WorkoutWidgetItem(index: index);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
