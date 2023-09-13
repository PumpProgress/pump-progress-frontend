import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';
import 'package:pump_progress_frontend/features/login/view/login_form.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.read<CoreBloc>().add(const CoreInit());
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.zero,
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                pumpProgressRepository: context.read<PumpProgressRepository>(),
              );
            },
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
