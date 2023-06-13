import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc/core_bloc.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';

import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

class App extends StatelessWidget {
  const App({super.key});
  static const router = PumpProgressRouter();

  @override
  Widget build(BuildContext context) {
    final providers = [
      RepositoryProvider<PumpProgressRepository>(
        create: (context) => PumpProgressRepository(),
      )
    ];
    return MultiRepositoryProvider(
      providers: providers,
      child: BlocProvider<CoreBloc>(
        create: (context) {
          return CoreBloc(
            pumpProgressRepository: context.read<PumpProgressRepository>(),
          )..add(const CoreInit());
        },
        child: MaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          onGenerateRoute: router.onGenerateRoute,
        ),
      ),
    );
  }
}
