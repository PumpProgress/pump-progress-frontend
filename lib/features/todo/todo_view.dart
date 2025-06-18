import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/utils/services/native_service/timer_service.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Text('COMING SOON 👾',
        //     style: Theme.of(context).textTheme.headlineMedium),
        child: OutlinedButton(
            onPressed: () async {
              await TimerService.startTimer(
                lastSetTime: DateTime.now(),
                exerciseName: "Bench Press",
                weight: 70,
                reps: 10,
              );
            },
            child: const Text('Start Timer')),
      ),
    );
  }
}
