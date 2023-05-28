import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/bloc/home_exercises_bloc.dart';
import 'package:pump_progress_frontend/features/home_exercises/view/home_exercises_view.dart';
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
        )
      ],
      child: DefaultTabController(
        length: 2,
        animationDuration: const Duration(),
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
          body: TabBarView(
            children: [
              const HomeExercises(),
              // Container(child: const Icon(Icons.directions_car)),
              Container(child: const Icon(Icons.directions_transit)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget tabs() {
  return Container(
    color: Colors.blue,
    child: const TabBar(
      // labelColor: Colors.white,
      // unselectedLabelColor: Colors.white70,
      // indicatorSize: TabBarIndicatorSize.tab,
      // indicatorPadding: EdgeInsets.all(5.0),
      // indicatorColor: Colors.blue,
      tabs: [
        Tab(
          text: "Exercises",
          icon: Icon(Icons.workspaces),
        ),
        Tab(
          text: "Calendar",
          icon: Icon(Icons.calendar_today),
        ),
      ],
    ),
  );
}
