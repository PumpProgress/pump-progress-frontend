import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/data/local_storage/local_storage_hive.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';
import 'package:pump_progress_frontend/features/login/view/login_form.dart';
import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreBloc, CoreState>(
      listener: (context, state) {
        print(state);
        if (state.status == AuthenticationStatus.authenticated) {
          context.read<CoreBloc>().add(const CoreInit());
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        /*appBar: AppBar(
          title: Text('login'),
        ),*/
        body: Padding(
          padding: EdgeInsets.zero,
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                localStorage: HiveStorage(),
                pumpProgressRepository: PumpProgressRepository(),
              );
            },
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
