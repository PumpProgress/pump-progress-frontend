import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';

import 'package:pump_progress_frontend/features/workout/blocs/bloc_workout/workout_bloc.dart';
import 'package:pump_progress_frontend/screens/start_workouts/view/start_workout_add_workout_button.dart';
import 'package:pump_progress_frontend/screens/start_workouts/view/start_workout_item.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';
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
    final userState = context.read<UserSessionBloc>().state;

    context
        .read<WorkoutBloc>()
        .add(FetchWorkoutEvent(userId: userState.user.id));
  }

  @override
  Widget build(BuildContext context) {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);

    return BlocConsumer<WorkoutBloc, WorkoutState>(
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
