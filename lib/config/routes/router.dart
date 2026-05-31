import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/routes/protected_route.dart';
import 'package:pump_progress_frontend/features/workout/domain/domain.dart';
import 'package:pump_progress_frontend/screens/error/error_page.dart';
import 'package:pump_progress_frontend/screens/exercise/exercise_page.dart';

import 'package:pump_progress_frontend/screens/exercise_analytics/exercise_analytics_page.dart';
import 'package:pump_progress_frontend/screens/main/start/start_page.dart';
import 'package:pump_progress_frontend/screens/login/login_page.dart';
import 'package:pump_progress_frontend/screens/ai/profile_chat/profile_chat_page.dart';
import 'package:pump_progress_frontend/screens/ai/workout_builder/workout_builder_page.dart';
import 'package:pump_progress_frontend/screens/ai/models/models_page.dart';
import 'package:pump_progress_frontend/screens/profile/profile_page.dart';
import 'package:pump_progress_frontend/screens/workout/workout_page.dart';
import 'package:pump_progress_frontend/utils/helpers/app_logger.dart';

class PumpProgressRouter {
  const PumpProgressRouter();

  Route<void> onGenerateRoute(RouteSettings settings) {
    AppLogger.debug("onGenerateRoute");
    AppLogger.debug(settings.name);

    switch (settings.name) {
      case PageStart.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: PageStart.routeName),
          builder: (_) => const ProtectedRoute(child: PageStart()),
        );
      case PageLogin.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: PageLogin.routeName),
          builder: (_) => const PageLogin(),
        );

      case PageExercise.routeName:
        final args = settings.arguments! as ExercisesPageArguments;
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: PageExercise.routeName),
          builder: (_) => ProtectedRoute(
            child: PageExercise(
              exerciseId: args.exerciseId,
            ),
          ),
        );

      case '/exercises/analytics':
        final args = settings.arguments! as ExercisesPageArguments;
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/exercises/analytics'),
          builder: (_) => ProtectedRoute(
            child: ExerciseAnalyticsPage(
              exerciseId: args.exerciseId,
              exerciseName: args.exerciseName,
            ),
          ),
        );
      case '/workouts':
        final args = settings.arguments! as WorkoutsPageArguments;
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/workouts'),
          builder: (_) => ProtectedRoute(
            child: WorkoutPage(
              workout: args.workout,
            ),
          ),
        );

      case ProfileChatPage.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: ProfileChatPage.routeName),
          builder: (_) => const ProtectedRoute(child: ProfileChatPage()),
        );

      case WorkoutBuilderPage.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: WorkoutBuilderPage.routeName),
          builder: (_) => const ProtectedRoute(child: WorkoutBuilderPage()),
        );

      case ModelsPage.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: ModelsPage.routeName),
          builder: (_) => const ProtectedRoute(child: ModelsPage()),
        );

      case ProfilePage.routeName:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: ProfilePage.routeName),
          builder: (_) => const ProtectedRoute(child: ProfilePage()),
        );

      default:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: PageError.routeName),
          builder: (_) => const PageError(),
        );
    }
  }
}

class ExercisesPageArguments {
  ExercisesPageArguments({
    required this.exerciseId,
    required this.exerciseName,
  });
  final int exerciseId;
  final String exerciseName;
}

class WorkoutsPageArguments {
  WorkoutsPageArguments({
    required this.workout,
  });
  final Workout workout;
}
