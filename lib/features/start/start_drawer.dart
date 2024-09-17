import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';

class StartDrawer extends StatelessWidget {
  const StartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                context.read<CoreBloc>().add(const CoreLogout());
              },
              leading: const Icon(Icons.power_settings_new_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
