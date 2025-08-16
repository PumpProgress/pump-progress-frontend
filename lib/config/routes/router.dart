import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/routes/protected_route.dart';
import 'package:pump_progress_frontend/features/error/error_page.dart';
import 'package:pump_progress_frontend/features/exercise/view/exercise_page.dart';
import 'package:pump_progress_frontend/features/exercise_analytics/exercise_analytics.dart';
import 'package:pump_progress_frontend/features/start/start_page.dart';
import 'package:pump_progress_frontend/features/login/login.dart';
import 'package:pump_progress_frontend/features/workout/view/workout_page.dart';
import 'package:pump_progress_frontend/repositories/models/workout.dart';

class PumpProgressRouter {
  const PumpProgressRouter();

  Route<void> onGenerateRoute(RouteSettings settings) {
    print("onGenerateRoute");
    print(settings.name);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const ProtectedRoute(child: Start()),
        );
      case '/login':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/login'),
          builder: (_) => const LoginPage(),
        );

      case ExercisePage.routeName:
        final args = settings.arguments! as ExercisesPageArguments;
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: ExercisePage.routeName),
          builder: (_) => ProtectedRoute(
            child: ExercisePage(
              exerciseId: args.exerciseId,
              exerciseName: args.exerciseName,
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

      default:
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/error'),
          builder: (_) => const ErrorPage(),
        );
    }
  }
}

class ExercisesPageArguments {
  ExercisesPageArguments({
    required this.exerciseId,
    required this.exerciseName,
  });
  final String exerciseId;
  final String exerciseName;
}

class WorkoutsPageArguments {
  WorkoutsPageArguments({
    required this.workout,
  });
  final Workout workout;
}
