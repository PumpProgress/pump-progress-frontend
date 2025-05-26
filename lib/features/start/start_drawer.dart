import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

class StartDrawer extends StatelessWidget {
  const StartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final coreBloc = context.read<CoreBloc>();
    final user = coreBloc.state.user;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text("Profile"),
              subtitle: Text("${user.name} (${user.email})"),
              leading: const Icon(Icons.person_rounded),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                coreBloc.add(const CoreLogout());
              },
              leading: const Icon(Icons.power_settings_new_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
