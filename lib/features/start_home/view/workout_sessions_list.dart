import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/start_home/bloc/start_home_bloc.dart';

class WorkoutSessionsListWidget extends StatelessWidget {
  WorkoutSessionsListWidget({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StartHomeBloc>().state;
    _scrollController.addListener(() {
      if (state.areMore &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        context.read<StartHomeBloc>().add(FetchNextWorkoutSessions());
      }
    });
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.workoutSessions.length +
          (state.status == StartHomeStatus.loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.workoutSessions.length) {
          return Center(child: CircularProgressIndicator());
        }
        return ListTile(title: Text(state.workoutSessions[index].id));
      },
    );
  }
}
