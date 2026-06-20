import 'package:flutter/widgets.dart';

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
