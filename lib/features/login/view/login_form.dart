import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/features/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        print(state);
        if (state.status == LoginStatus.success) {
          context.read<CoreBloc>().add(const CoreInit());
          Navigator.pushReplacementNamed(context, '/');
        }
        // if (state.status.isSubmissionFailure) {
        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       const SnackBar(content: Text('Authentication Failure')),
        //     );
        // }
        // if (state.status.isSubmissionSuccess) {
        //   BlocProvider.of<AuthBloc>(context).add(AuthLoggedIn());
        // }
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
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Colors.black87),
              ),

              const Spacer(
                flex: 2,
              ),
              _EmailInput(),
              const Spacer(),
              _PasswordInput(),
              const Spacer(),
              // Align(
              //     alignment: Alignment.centerRight,
              //     child: GestureDetector(
              //       onTap: () {
              //         Navigator.pushNamed(context, '/recover-password');
              //       },
              //       child: Text(
              //         '¿Olvidaste tu contraseña?',
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodyText1!
              //             .copyWith(color: Colors.black87),
              //       ),
              //     )),
              const Spacer(
                flex: 2,
              ),
              _LoginButton(),
              // const Spacer(
              //   flex: 2,
              // ),
              // Wrap(alignment: WrapAlignment.center, children: [
              //   Text(
              //     '¿No estás registrado aún? ',
              //     style: Theme.of(context)
              //         .textTheme
              //         .bodyText1!
              //         .copyWith(color: Colors.black87),
              //   ),
              //   GestureDetector(
              //       onTap: () {
              //         Navigator.pushNamed(context, '/register');
              //       },
              //       child: Text(
              //         'Crea una cuenta',
              //         style: Theme.of(context).textTheme.bodyText1!.copyWith(
              //               fontWeight: FontWeight.w700,
              //               decoration: TextDecoration.underline,
              //             ),
              //       ))
              // ])
              //_RegisterButton(),
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
          keyboardType: TextInputType.emailAddress,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(email)),
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
          // prefixIconData: CustomIcons.user,
          // errorText: state.email.invalid
          //     ? '${' ' * ConstantsSizes.sizes[0].toInt()}invalid username'
          //     : null,
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
          //inputType: TextInputType.visiblePassword,
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Contraseña',
          ),
          // prefixIconData: CustomIcons.lock_close,
          // errorText: state.password.invalid
          //     ? '${' ' * ConstantsSizes.sizes[0].toInt()}invalid password'
          //     : null,
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
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87))
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
                child: Text('Inicia sesión',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontSize: 14)));
      },
    );
  }
}
