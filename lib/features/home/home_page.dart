import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';

import 'package:pump_progress_frontend/features/home/home_drawer.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercises_view.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workouts_view.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    print('test3');
    context
        .read<WorkoutsBloc>()
        .add(const FetchWorkoutsEvent()); // TODO event not being emited
    print('test4');

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeExercisesBloc>(
          create: (context) => HomeExercisesBloc(
            pumpProgressRepository: context.read<PumpProgressRepository>(),
            coreBloc: context.read<CoreBloc>(),
          )..add(const HardFetchExerciseListEvent()),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        animationDuration: const Duration(),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Pump Progress'),
              ),
              drawer: const HomeDrawer(),
              bottomNavigationBar: tabs(),
              body: const TabBarView(
                children: [HomeExercises(), HomeWorkouts()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget tabs() {
  return const TabBar(
    tabs: [
      Tab(
        text: "Exercises",
        icon: Icon(Icons.workspaces),
      ),
      Tab(
        text: "Workouts",
        icon: Icon(Icons.airline_seat_individual_suite_outlined),
      ),
    ],
  );
}
