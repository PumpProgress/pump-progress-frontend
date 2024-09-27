import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';

import 'package:pump_progress_frontend/config/constants/theme.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/flavors.dart';

import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  const App({super.key});
  static const router = PumpProgressRouter();

  @override
  Widget build(BuildContext context) {
    print("Flavor: ${F.appFlavor}");
    // print("Flavor PPApiUrl: ${F.ppApiUrl}");
    final repositoryProviders = [
      RepositoryProvider<PumpProgressRepository>(
        create: (context) => PumpProgressRepository(),
      )
    ];

    final blocProviders = [
      BlocProvider(create: (context) {
        return CoreBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        )..add(const CoreInit());
      }),
      BlocProvider(create: (context) {
        return WorkoutsBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        );
      })
    ];

    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: MultiBlocProvider(
        providers: blocProviders,
        child: MaterialApp(
          theme: theme,
          onGenerateRoute: router.onGenerateRoute,
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
