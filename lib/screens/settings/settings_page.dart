import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/screens/settings/view/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    // Reads the app-wide RepositorySettings; no screen-scoped BLoC needed.
    return const SettingsView();
  }
}
