import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.read<CoreBloc>().add(const CoreInit());
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Padding(
          padding: const EdgeInsets.all(46),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'PumpProgress',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Spacer(
                flex: 2,
              ),
              _EmailInput(),
              const Spacer(),
              _PasswordInput(),
              const Spacer(),
              const Spacer(
                flex: 2,
              ),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(email)),
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
            labelText: 'Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PumpProgressColors.coral,
                  foregroundColor: PumpProgressColors.white,
                ),
                onPressed: () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
                child: Text(
                  'LogIn',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: PumpProgressColors.white),
                ),
              );
      },
    );
  }
}
