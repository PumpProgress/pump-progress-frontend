import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/auth/repository/repository.dart';
import 'package:pump_progress_frontend/features/sets/repositories/repositories.dart';

import 'package:pump_progress_frontend/flavors.dart';

// * Config
import 'package:pump_progress_frontend/config/theme/theme.dart';
import 'package:pump_progress_frontend/config/routes/router.dart';

// * Features
import 'package:pump_progress_frontend/features/user/repository/repository.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/features/exercise/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/sync/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/sync/repository/repository.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository.dart';

// * Utils
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_event_bus.dart';
import 'package:pump_progress_frontend/utils/helpers/route_observer.dart';

import 'package:pump_progress_frontend/screens/loading/loading_page.dart';

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
    AppLogger.info("Flavor: ${F.appFlavor}");

    final repositoryProviders = [
      RepositoryProvider<RepositoryUser>(
        create: (context) => RepositoryUser(),
      ),
      RepositoryProvider<RepositorySync>(
        create: (context) => RepositorySync(),
      ),
      RepositoryProvider<RepositoryAuth>(
        create: (context) => RepositoryAuth(),
      ),
      RepositoryProvider<RepositoryWorkout>(
        create: (context) => RepositoryWorkout(),
      ),
      RepositoryProvider<RepositoryExercises>(
        create: (context) => RepositoryExercises(),
      ),
      RepositoryProvider<RepositorySets>(
        create: (context) => RepositorySets(),
      ),
    ];

    final blocProviders = [
      BlocProvider(create: (context) {
        return WorkoutBloc(
            repositoryWorkout: context.read<RepositoryWorkout>());
      }),
      BlocProvider(
          lazy: false,
          create: (context) {
            return ExercisesBloc(
                repositoryExercises: context.read<RepositoryExercises>());
          }),
      BlocProvider(
          lazy: false,
          create: (context) {
            return AiBloc()..add(const AiInitEvent());
          }),
      BlocProvider(create: (context) {
        return SyncBloc(
          repositorySync: context.read<RepositorySync>(),
        );
      }),
    ];

    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: BlocProvider(
        create: (context) {
          return UserSessionBloc(repositoryUser: context.read<RepositoryUser>())
            ..add(const UserSessionInitEvent());
        },
        child: MultiBlocProvider(
          providers: blocProviders,
          child: BlocConsumer<UserSessionBloc, UserSessionState>(
            listener: (context, state) {
              if (state.status is UserSessionStatusAuthenticated) {
                context.read<SyncBloc>().add(StartSyncEvent());
              }
            },
            builder: (context, state) {
              final syncStateStatus = context.select<SyncBloc, SyncBlocStatus>(
                  (bloc) => bloc.state.status);

              if (syncStateStatus is SyncBlocStatusInProgress) {
                return LoadingPage();
              }

              if (syncStateStatus is SyncBlocStatusError) {
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
          ),
        ),
      ),
    );
  }
}
