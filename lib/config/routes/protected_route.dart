import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/features/splash/splash_page.dart';

class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(listener: (context, state) {
      if (state.status == AuthenticationStatus.unauthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      if (state.status == AuthenticationStatus.unknown) {
        print('coreBlocListener');
        // context.read<CoreBloc>().add(const CoreInit());
        return;
      }
    }, child: BlocBuilder<CoreBloc, CoreState>(
      builder: (context, state) {
        print('protected child');
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            return child;
          // ignore: no_default_cases
          default:
            return const SplashPage();
        }
      },
    ));
  }
}
