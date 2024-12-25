import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

import 'package:pump_progress_frontend/features/splash/splash_page.dart';

class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          Navigator.of(context).popAndPushNamed('/login');
          return;
        }
      },
      child: BlocBuilder<CoreBloc, CoreState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              return child;
            case AuthenticationStatus.unknown:
              print('protected route: unknown');
              return const SplashPage();
            case AuthenticationStatus.unauthenticated:
              print('protected route: unauthenticated');
              return const SplashPage();
          }
        },
      ),
    );
  }
}
