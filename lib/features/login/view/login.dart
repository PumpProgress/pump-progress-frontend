import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';

import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';
import 'package:pump_progress_frontend/features/login/view/login_form.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/services/cognito_user_pool/cognito_user_pool.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
          userPool: context.read<PPUserPool>(),
        );
      },
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            print('Login page. loginStatus.state.status == authenticated');
            context.read<CoreBloc>().add(const CoreInit());
            Navigator.of(context).pushReplacementNamed('/');
          }
          if (state.status == LoginStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'An error occurred'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.loading ||
              state.status == LoginStatus.success) {
            return const LoadingPage();
          }
          return const Scaffold(
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: EdgeInsets.zero,
              child: LoginForm(),
            ),
          );
        },
      ),
    );
  }
}
