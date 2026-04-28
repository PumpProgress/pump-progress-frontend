import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/auth/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/loading/loading_page.dart';

import 'package:pump_progress_frontend/screens/login/views/login_form.dart';
import 'package:pump_progress_frontend/screens/main/start/start_page.dart';
import 'package:pump_progress_frontend/utils/services/native_service/timer_service.dart';

class ViewLogin extends StatelessWidget {
  const ViewLogin({super.key});

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status is LoginStatusSuccess) {
          context.read<UserSessionBloc>().add(const UserSessionInitEvent());
          Navigator.of(context).pushReplacementNamed(PageStart.routeName);
        }
      },
      builder: (context, state) {
        if (state.status is LoginStatusLoading ||
            state.status is LoginStatusSuccess) {
          return LoadingPage();
        }
        return const Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.zero,
            child: LoginForm(),
          ),
        );
      },
    );
  }
}
