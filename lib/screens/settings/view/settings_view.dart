import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/settings/repository/repository.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = context.read<RepositorySettings>().appVersion();
  }

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
          // Rate app option hidden for now.
          // ListTile(
          //   leading: const Icon(Icons.star_rounded),
          //   title: const Text('Rate app'),
          //   onTap: () => _run(context, repo.rateApp, 'Could not open review'),
          // ),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text('Share app'),
            onTap: () => _run(context, repo.shareApp, 'Could not share'),
          ),
          FutureBuilder<String>(
            future: _versionFuture,
            builder: (context, snapshot) {
              final String subtitle;
              if (snapshot.connectionState != ConnectionState.done) {
                subtitle = '…';
              } else if (snapshot.hasError || snapshot.data == null) {
                subtitle = '—';
              } else {
                subtitle = snapshot.data!;
              }
              return ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Version'),
                subtitle: Text(subtitle),
              );
            },
          ),
        ],
      ),
    );
  }
}
