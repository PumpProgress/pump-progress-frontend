import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class TimerService {
  static const _channel = MethodChannel("com.xrok.pumpProgress/timer");

  static Future<void> startTimer(
      {required DateTime lastSetTime,
      required String exerciseName,
      required double weight,
      required int reps}) async {
    debugPrint("📟 TimerService.startTimer called with $lastSetTime");

    if (Platform.isIOS || Platform.isAndroid) {
      try {
        debugPrint("📟 isIOS or Android $lastSetTime");
        await _channel.invokeMethod("startTimerService", {
          "lastSetTime": lastSetTime.millisecondsSinceEpoch,
          "exercise": exerciseName,
          "weight": weight,
          "reps": reps,
        });
        debugPrint("✅ TimerService started successfully");
      } catch (e) {
        debugPrint("❌ Failed to start native timer: $e");
      }
    } else {
      debugPrint("🧪 Timer not supported on ${Platform.operatingSystem}");
    }
  }

  static Future<void> stopTimer() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _channel.invokeMethod("stopTimerService");
      } catch (e) {
        debugPrint("❌ Failed to stop timer service: $e");
      }
    }
  }
}
