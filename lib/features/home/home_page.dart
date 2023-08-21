import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercises_view.dart';
import 'package:pump_progress_frontend/features/home_workouts/bloc/home_workouts_bloc.dart';
import 'package:pump_progress_frontend/features/home_workouts/view/home_workouts_view.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeExercisesBloc>(
          create: (context) => HomeExercisesBloc(
            pumpProgressRepository: context.read<PumpProgressRepository>(),
            coreBloc: context.read<CoreBloc>(),
          )..add(const HardFetchExerciseListEvent()),
        ),
        BlocProvider(
          create: (context) => HomeWorkoutsBloc(
              pumpProgressRepository: context.read<PumpProgressRepository>(),
              coreBloc: context.read<CoreBloc>())
            ..add(const FetchHomeWorkoutsEvent()),
        )
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
              drawer: Drawer(
                child: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () {
                          context.read<CoreBloc>().add(const CoreLogout());
                        },
                        leading: const Icon(Icons.power_settings_new_rounded),
                      ),
                    ],
                  ),
                ),
              ),
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
