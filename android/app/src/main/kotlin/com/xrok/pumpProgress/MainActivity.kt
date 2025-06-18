package com.xrok.pumpProgress

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.xrok.pumpProgress/timer")
            .setMethodCallHandler { call, result ->
            when (call.method) {
                "startTimerService" -> {
                    val time = call.argument<Long>("lastSetTime") ?: 0L
                    val exercise = call.argument<String>("exercise") ?: ""
                    val weight = call.argument<Double>("weight") ?: 0.0
                    val reps = call.argument<Int>("reps") ?: 0

                    val intent = Intent(this, TimerService::class.java).apply {
                        putExtra("lastSetTime", time)
                        putExtra("exercise", exercise)
                        putExtra("weight", weight)
                        putExtra("reps", reps)
                    }
                    startForegroundService(intent)
                    result.success(null)
                }

                "stopTimerService" -> {
                    val intent = Intent(this, TimerService::class.java)
                    stopService(intent)
                    result.success(null)
                }
            }
        }
    }
}