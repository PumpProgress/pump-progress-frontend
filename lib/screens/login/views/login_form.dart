import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/auth/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/login/views/federated_login_web_view.dart';

const _federatedLogins = <Map<String, String>>[
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

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status is LoginStatusProviderLogIn) {
          return FederatedLoginWebView(provider: state.provider);
        }
        if (state.status is LoginStatusSuccess ||
            state.status is LoginStatusLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Align(
          alignment: const Alignment(0, -1 / 3),
          child: Padding(
            padding: const EdgeInsets.all(46),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Text(
                  'PUMP\nPROGRESS',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const Spacer(flex: 1),
                // pump-logo-inverted
                SvgPicture.asset(
                  'assets/svg/pump-logo-inverted.svg',
                  width: 150,
                  height: 150,
                ),
                const Spacer(flex: 1),
                Text(
                  'make every rep count...',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Spacer(flex: 1),
                ..._getFederatedLoginButtons(context),
                const Spacer(
                  flex: 3,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Widget> _getFederatedLoginButtons(BuildContext context) {
  return _federatedLogins
      .map(
        (login) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton(
              key:
                  Key('loginForm_login${login['provider']}Button_raisedButton'),
              style: ElevatedButton.styleFrom(
                foregroundColor: PPColors.neutral500,
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
                  const SizedBox(width: 20),
                  Text('Continue with ${login['name']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: PPColors.neutral500)),
                ],
              ),
            ),
          ),
        ),
      )
      .toList();
}
