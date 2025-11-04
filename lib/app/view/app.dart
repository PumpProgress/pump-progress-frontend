import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_exercises/exercises_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_workouts/workouts_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_sync/sync_bloc.dart';

import 'package:pump_progress_frontend/config/constants/theme.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';
import 'package:pump_progress_frontend/features/loading/loading_page.dart';
import 'package:pump_progress_frontend/flavors.dart';

import 'package:pump_progress_frontend/repositories/pump_progress_repository.dart';
import 'package:pump_progress_frontend/utils/helpers/error_event_bus.dart';
import 'package:pump_progress_frontend/utils/helpers/route_observer.dart';
import 'package:pump_progress_frontend/utils/services/cognito_user_pool/cognito_user_pool.dart';

class App extends StatefulWidget {
  const App({super.key});
  static const router = PumpProgressRouter();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<String> _sub;
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _sub = ErrorEventBus.stream.listen((message) {
      final messenger = messengerKey.currentState;
      messenger?.showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Flavor: ${F.appFlavor}");

    final repositoryProviders = [
      RepositoryProvider<PumpProgressRepository>(
        create: (context) => PumpProgressRepository(),
      ),
      RepositoryProvider<PPUserPool>(
        create: (context) => PPUserPool(),
      )
    ];
    final blocProviders = [
      BlocProvider(create: (context) {
        return WorkoutsBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        );
      }),
      BlocProvider(create: (context) {
        return ExercisesBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        )..add(FetchExercisesEvent());
      }),
      BlocProvider(create: (context) {
        return SyncBloc(
          pumpProgressRepository: context.read<PumpProgressRepository>(),
        );
      }),
    ];

    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: BlocProvider(
          create: (context) {
            return CoreBloc(
              pumpProgressRepository: context.read<PumpProgressRepository>(),
            )..add(const CoreInit());
          },
          child: MultiBlocProvider(
              providers: blocProviders,
              child: BlocConsumer<CoreBloc, CoreState>(
                listener: (context, state) {
                  if (state.status == AuthenticationStatus.authenticated) {
                    context.read<SyncBloc>().add(StartSyncEvent());
                  }
                },
                builder: (context, state) {
                  final syncStateStatus = context.select<SyncBloc, SyncStatus>(
                      (bloc) => bloc.state.status);

                  if (syncStateStatus == SyncStatus.inProgress) {
                    return LoadingPage();
                  }

                  if (syncStateStatus == SyncStatus.failure) {
                    return LoadingPage();
                  }

                  return MaterialApp(
                    scaffoldMessengerKey: messengerKey,
                    theme: theme,
                    onGenerateRoute: App.router.onGenerateRoute,
                    navigatorObservers: [routeObserver],
                    debugShowCheckedModeBanner: false,
                  );
                },
              ))),
    );
  }
}
