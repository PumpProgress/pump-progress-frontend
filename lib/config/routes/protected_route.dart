import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(listener: (context, state) {
      if (state.status == AuthenticationStatus.unauthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      if (state.status == AuthenticationStatus.unknown) {
        // emit event validate token
        return;
      }
    }, child: BlocBuilder<CoreBloc, CoreState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            return child;
          default:
            return const LoadingPage();
        }
      },
    ));
  }
}
