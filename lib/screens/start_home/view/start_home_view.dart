import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';
import 'package:pump_progress_frontend/screens/start_home/bloc/start_home_bloc.dart';
import 'package:pump_progress_frontend/screens/start_home/view/workout_sessions_list.dart';
import 'package:pump_progress_frontend/screens/todo/todo_view.dart';

class StartHomeView extends StatelessWidget {
  const StartHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<StartHomeBloc, StartHomeState>(
    //   listener: (context, state) {},
    //   builder: (context, state) {
    //     if (state.status == StartHomeStatus.loading) {
    //       return const LoadingPage();
    //     }
    //     return WorkoutSessionsListWidget();
    //   },
    // );
    return ComingSoonPage();
  }
}
