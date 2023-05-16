import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      animationDuration: Duration(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pump Progress'),
        ),
        bottomNavigationBar: tabs(),
        body: TabBarView(
          children: [
            Container(child: const Icon(Icons.directions_car)),
            Container(child: const Icon(Icons.directions_transit)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<CoreBloc>().add(const CoreLogout()),
          tooltip: 'Logout',
          child: const Icon(Icons.logout),
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
