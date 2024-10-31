import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

import 'package:pump_progress_frontend/config/constants/colors.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';
import 'package:pump_progress_frontend/features/login/view/federated_login_web_view.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          print('Login form. LoginBloc.state.status == success');
          context.read<CoreBloc>().add(const CoreInit());
          Navigator.of(context).pushReplacementNamed('/');
        }
        if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'An error occurred'),
              duration: const Duration(seconds: 5), // Display for 5 seconds
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == LoginStatus.providerLogIn) {
          return FederatedLoginWebView(provider: state.provider);
        }

        return Align(
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
                const Spacer(flex: 2),
                ...getFederatedLoginButtons(context),
                const Spacer(
                  flex: 4,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

const federatedLogins = <Map<String, String>>[
  {
    'provider': 'SignInWithApple',
    'icon': 'assets/svg/icon-apple.svg',
    'name': 'Apple'
  },
  {
    'provider': 'Google',
    'icon': 'assets/svg/icon-google.svg',
    'name': 'Google'
  },
];

List<Widget> getFederatedLoginButtons(BuildContext context) {
  return federatedLogins
      .map(
        (login) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton(
              key:
                  Key('loginForm_login${login['provider']}Button_raisedButton'),
              style: ElevatedButton.styleFrom(
                foregroundColor: PPColors.black,
                backgroundColor: PPColors.white,
              ),
              onPressed: () {
                context
                    .read<LoginBloc>()
                    .add(LoginWithProvider(provider: login['provider']!));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    login['icon']!,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text('Continue with ${login['name']}'),
                ],
              ),
            ),
          ),
        ),
      )
      .toList();
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
                  backgroundColor: PPColors.coral300,
                  foregroundColor: PPColors.white,
                ),
                onPressed: () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
                child: Text(
                  'LogIn',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: PPColors.white),
                ),
              );
      },
    );
  }
}
