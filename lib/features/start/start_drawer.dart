import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/app/bloc_core/core_bloc.dart';
import 'package:pump_progress_frontend/utils/services/native_service/timer_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class StartDrawer extends StatelessWidget {
  const StartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final coreBloc = context.read<CoreBloc>();
    final user = coreBloc.state.user;
    return Drawer(
      child: SafeArea(
        child: Column(
          // padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text("Profile"),
              subtitle: Text("${user.name} (${user.email})"),
              leading: const Icon(Icons.person_rounded),
              onLongPress: () async {
                // Send a test error to Sentry
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
              title: const Text('Send Test Prompt to AI'),
              onTap: () async {
                BlocProvider.of<AiBloc>(context)
                    .add(SendPromptEvent("cuanto es 2+2"));
              },
              leading: const Icon(Icons.notifications_active_rounded),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                coreBloc.add(const CoreLogout());
              },
              leading: const Icon(Icons.power_settings_new_rounded),
            ),
            Spacer(),
            ListTile(
              title: Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // open a confirmation dialog before deleting
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete Account"),
                      content: Text(
                          "Are you sure you want to delete your account? This action cannot be undone."),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // Call the delete account function
                            coreBloc.add(CoreDeleteAccount());
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
