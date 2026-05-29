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
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_profile_chat/profile_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_workout_builder_chat/workout_builder_chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/services/gemma_model_service.dart';
import 'package:pump_progress_frontend/features/ai/tools/ai_tool_dispatcher.dart';
import 'package:pump_progress_frontend/features/exercise/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/exercise/repository/repository.dart';
import 'package:pump_progress_frontend/features/muscle/repository/repository_muscle.dart';
import 'package:pump_progress_frontend/features/sync/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/sync/repository/repository.dart';
import 'package:pump_progress_frontend/features/workout/blocs/blocs.dart';
import 'package:pump_progress_frontend/features/workout/repository/repository.dart';

// * Utils
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';
import 'package:pump_progress_frontend/utils/helpers/error_event_bus.dart';
import 'package:pump_progress_frontend/utils/helpers/route_observer.dart';

// import 'package:pump_progress_frontend/screens/loading/loading_page.dart';

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
      RepositoryProvider<ProviderMuscle>(
        create: (context) => ProviderMuscle(),
      ),
      RepositoryProvider<RepositorySets>(
        create: (context) => RepositorySets(),
      ),
      RepositoryProvider<GemmaModelService>(
        create: (_) => GemmaModelService(),
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
        create: (context) => GemmaModelBloc(
          modelService: context.read<GemmaModelService>(),
        )..add(const GemmaModelInitEvent()),
      ),
      BlocProvider(
        create: (context) => ProfileChatBloc(
          modelService: context.read<GemmaModelService>(),
        ),
      ),
      BlocProvider(
        create: (context) => WorkoutBuilderChatBloc(
          modelService: context.read<GemmaModelService>(),
          toolDispatcher: AiToolDispatcher(
            repositoryExercises: context.read<RepositoryExercises>(),
            providerMuscle: context.read<ProviderMuscle>(),
          ),
        ),
      ),
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
          child: BlocListener<SyncBloc, SyncState>(
            listener: (context, syncState) {
              if (syncState.status
                  case SyncBlocStatusSuccess(:final result)
                  when result.hasData) {
                final parts = [
                  if (result.totalReceived > 0)
                    '${result.totalReceived} received',
                  if (result.totalSent > 0) '${result.totalSent} uploaded',
                ];
                messengerKey.currentState?.showSnackBar(
                  SnackBar(content: Text('Sync complete — ${parts.join(', ')}')),
                );
              }
            },
            child: BlocConsumer<UserSessionBloc, UserSessionState>(
              listener: (context, state) {
                if (state.status is UserSessionStatusAuthenticated) {
                  context.read<SyncBloc>()
                    ..add(const StartSyncEvent())
                    ..add(const StartPeriodicSyncEvent());
                } else if (state.status is UserSessionStatusUnauthenticated) {
                  context.read<SyncBloc>().add(const StopPeriodicSyncEvent());
                }
              },
              builder: (context, state) {
                // final syncStateStatus = context.select<SyncBloc, SyncBlocStatus>(
                //     (bloc) => bloc.state.status);

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
      ),
    );
  }
}
