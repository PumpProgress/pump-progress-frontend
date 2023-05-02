import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/routes/protected_route.dart';
import 'package:pump_progress_frontend/features/error/error_page.dart';
import 'package:pump_progress_frontend/features/home/home_page.dart';

class PumpProgressRouter {
  Route onGenerateRoute(RouteSettings settings) {
    //final GlobalKey<ScaffoldState> key = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const ProtectedRoute(child: Home()),
        );
      case '/login':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/login'),
          builder: (_) => const LoginPage(),
        );

      default:
        return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/error'),
            builder: (_) => const ErrorPage());
    }
  }
}
