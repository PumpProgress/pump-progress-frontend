import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/auth/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/auth/repository/repository.dart';
import 'package:pump_progress_frontend/screens/login/view/login_view.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        repositoryAuth: context.read<RepositoryAuth>(),
      ),
      child: const ViewLogin(),
    );
  }
}
