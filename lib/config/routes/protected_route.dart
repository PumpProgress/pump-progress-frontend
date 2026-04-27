import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';
import 'package:pump_progress_frontend/screens/splash/splash_page.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';

class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserSessionBloc, UserSessionState>(
      listener: (context, state) {
        if (state.status is UserSessionStatusUnauthenticated) {
          Navigator.of(context).popAndPushNamed('/login');
          return;
        }
        if (state.status is UserSessionStatusError) {
          AppLogger.error('Error in ProtectedRoute: ${state.status}');
          Navigator.of(context).popAndPushNamed('/login');
          return;
        }
      },
      child: BlocBuilder<UserSessionBloc, UserSessionState>(
        builder: (context, state) {
          switch (state.status) {
            case UserSessionStatusAuthenticated():
              return child;
            case UserSessionStatusUnauthenticated():
              return const SplashPage();
            case UserSessionStatusLoading():
              return const LoadingPage();
            case UserSessionStatusError():
              AppLogger.error('Error in ProtectedRoute: ${state.status}');
              return const SplashPage();
          }
        },
      ),
    );
  }
}
