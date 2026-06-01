import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/sync/blocs/bloc_sync/sync_bloc.dart';
import 'package:pump_progress_frontend/features/user/blocs/blocs.dart';
import 'package:pump_progress_frontend/screens/ai/models/models_page.dart';
import 'package:pump_progress_frontend/screens/profile/profile_page.dart';
import 'package:pump_progress_frontend/utils/services/native_service/timer_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class StartDrawer extends StatelessWidget {
  const StartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final coreBloc = context.read<UserSessionBloc>();
    final user = coreBloc.state.user;
    final syncHistory = context.watch<SyncBloc>().state.history;
    final lastAttempt = syncHistory.isEmpty ? null : syncHistory.last;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Profile"),
              subtitle: Text("${user.name} (${user.email})"),
              leading: const Icon(Icons.person_rounded),
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
              onLongPress: () async {
                await Sentry.captureException(
                  Exception(
                      'Test Sentry error from Profile - connection is working!'),
                  stackTrace: StackTrace.current,
                );
              },
            ),
            ListTile(
              title: const Text('Stop Series Timer'),
              onTap: () async {
                await TimerService.stopTimer();
              },
              leading: const Icon(Icons.notifications_off_rounded),
            ),
            ListTile(
              leading: Icon(
                lastAttempt == null
                    ? Icons.cloud_rounded
                    : lastAttempt.success
                        ? Icons.cloud_done_rounded
                        : Icons.cloud_off_rounded,
                color: lastAttempt == null
                    ? null
                    : lastAttempt.success
                        ? Colors.green
                        : Colors.red,
              ),
              title: const Text('Last sync'),
              subtitle: Text(
                lastAttempt == null
                    ? 'Never synced'
                    : _formatTimestamp(lastAttempt.timestamp),
              ),
            ),
            ListTile(
              title: const Text('Sync tables'),
              onTap: () async {
                BlocProvider.of<SyncBloc>(context).add(const StartSyncEvent());
              },
              leading: const Icon(Icons.cloud_sync_rounded),
            ),
            ListTile(
              title: const Text('AI Models'),
              onTap: () {
                Navigator.pushNamed(context, ModelsPage.routeName);
              },
              leading: const Icon(Icons.smart_toy_rounded),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                coreBloc.add(const UserSessionLogoutEvent());
              },
              leading: const Icon(Icons.power_settings_new_rounded),
            ),
            const Spacer(),
            ListTile(
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                          "Are you sure you want to delete your account? This action cannot be undone."),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            coreBloc.add(const UserSessionDeleteAccountEvent());
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return '$hh:$mm';
    }
    final dd = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$dd/$mo $hh:$mm';
  }
}
