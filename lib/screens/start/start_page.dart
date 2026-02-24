import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/config/constants/icomoon_icons.dart';
import 'package:pump_progress_frontend/features/sets/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';

import 'package:pump_progress_frontend/screens/start/start_drawer.dart';
import 'package:pump_progress_frontend/screens/start_calendar/view/start_calendar_view.dart';
import 'package:pump_progress_frontend/screens/start_exercises/bloc/start_exercises_bloc.dart';
import 'package:pump_progress_frontend/screens/start_home/bloc/start_home_bloc.dart';
import 'package:pump_progress_frontend/screens/start_home/view/start_home_view.dart';
import 'package:pump_progress_frontend/screens/start_workouts/view/start_workouts_view.dart';

List<String> _titles = [
  'Home',
  // 'Community',
  'Calendar',
  // 'Exercises',
  'Workouts'
];

const int _defaultIndex = 1;

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _appBarTitle = _titles[_defaultIndex];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: _titles.length, vsync: this, initialIndex: _defaultIndex);

    _tabController.addListener(() {
      setState(() {
        _appBarTitle = _titles[_tabController.index];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = context.read<UserSessionBloc>().state.user;

    return MultiBlocProvider(
      providers: [
        // BlocProvider<StartExercisesBloc>(
        //   create: (context) => StartExercisesBloc(
        //     me: me,
        //     pumpProgressRepository: context.read<PumpProgressRepository>(),
        //   )..add(const HardFetchExerciseListEvent()),
        // ),
        BlocProvider<CalendarBloc>(
            create: (context) =>
                CalendarBloc(repositorySets: context.read<RepositorySets>())),
        // BlocProvider<StartHomeBloc>(
        //   create: (context) => StartHomeBloc(
        //     pumpProgressRepository: context.read<PumpProgressRepository>(),
        //   )..add(FetchInitialWorkoutSessions()),
        // ),
      ],
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _appBarTitle,
                // style: PPFontStyles.h4.copyWith(color: PPColors.neutral100),
              ),
              elevation: 0,
            ),
            drawer: const StartDrawer(),
            bottomNavigationBar: TabBar(
              controller: _tabController,
              enableFeedback: true,
              unselectedLabelColor: PPColors.amethyst300,
              labelColor: PPColors.coral300,
              indicator: const BoxDecoration(),
              indicatorColor: Colors.transparent,
              indicatorWeight: 0.0,
              dividerColor: Colors.transparent,
              tabs: _tabs(),
            ),
            body: TabBarView(
              controller: _tabController,
              children: const [
                StartHomeView(), // * Home
                // ComingSoonPage(), // * Community
                StartCalendarView(), // * Calendar
                // StartExercises(), // * Exercises
                StartWorkouts(), // * Workouts
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Tab> _tabs() {
  return const [
    Tab(
      icon: Icon(
        Icomoon.icon_home,
        size: 32,
      ),
    ),
    // Tab(
    //   icon: Icon(
    //     Icomoon.icon_community,
    //     size: 32,
    //   ),
    // ),
    Tab(
      icon: Icon(
        Icomoon.icon_calendar,
        size: 32,
      ),
    ),
    // Tab(
    //   icon: Icon(
    //     Icomoon.icon_dumbell,
    //     size: 32,
    //   ),
    // ),
    Tab(
      icon: Icon(
        Icomoon.icon_thunder,
        size: 32,
      ),
    ),
  ];
}
