import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/screens/profile/view/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    // Reads the app-wide UserSessionBloc; no screen-scoped BLoC needed.
    return const ProfileView();
  }
}
