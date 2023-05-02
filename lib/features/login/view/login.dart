import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
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
                // userRepository: RepositoryProvider.of<UserRepository>(context),
              );
            },
            child: 
              const LoginForm();
            ),
          ),
        ),
      ),
    );
  }
}
