import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/settings/repository/repository.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String failureMessage,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failureMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<RepositorySettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded),
            title: const Text('Privacy Policy'),
            onTap: () => _run(
              context,
              repo.openPrivacyPolicy,
              'Could not open privacy policy',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.star_rounded),
            title: const Text('Rate app'),
            onTap: () => _run(context, repo.rateApp, 'Could not open review'),
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text('Share app'),
            onTap: () => _run(context, repo.shareApp, 'Could not share'),
          ),
          FutureBuilder<String>(
            future: repo.appVersion(),
            builder: (context, snapshot) {
              return ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Version'),
                subtitle: switch (snapshot.connectionState) {
                  ConnectionState.done => Text(snapshot.data ?? 'Unknown'),
                  _ => const Text('…'),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
