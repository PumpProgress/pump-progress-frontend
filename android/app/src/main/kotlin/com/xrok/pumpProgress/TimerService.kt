package com.xrok.pumpProgress
import android.util.Log

import android.app.*
import android.content.*
import android.os.*
import androidx.core.app.NotificationCompat

class TimerService : Service() {
    private var exerciseName: String = ""
    private var weight: Double = 0.0
    private var reps: Int = 0

    private var lastSetTime: Long = 0L
    private val handler = Handler(Looper.getMainLooper())
    private val runnable = object : Runnable {
        override fun run() {
            updateNotification()
            handler.postDelayed(this, 1000) // update every second
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("TimerService", "Service started with lastSetTime=$lastSetTime")
        lastSetTime = intent?.getLongExtra("lastSetTime", 0L) ?: 0L
        exerciseName = intent?.getStringExtra("exercise") ?: ""
        weight = intent?.getDoubleExtra("weight", 0.0) ?: 0.0
        reps = intent?.getIntExtra("reps", 0) ?: 0
        startForeground(NOTIF_ID, buildNotification())
        handler.post(runnable)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(runnable)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun updateNotification() {
        val now = System.currentTimeMillis()
        val elapsed = now - lastSetTime

        val minutes = (elapsed / 60000).toInt()
        val seconds = ((elapsed % 60000) / 1000).toInt()

        val timeText = String.format("%02d:%02d", minutes, seconds)
        val title = "💪 $exerciseName ($weight kg × $reps)"
        val text = "⏱ Last set: $timeText ago"

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_notification)
            .setOnlyAlertOnce(true)  // don’t play sound each update
            .setOngoing(true)        // don't allow swipe-away
            .build()

        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIF_ID, notification)
    }

    private fun buildNotification(): Notification {
        createChannel()
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("PumpProgress")
            .setContentText("⏱ Tracking last set…")
            .setSmallIcon(R.drawable.ic_notification)
            .build()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID, "Set Tracker", NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    companion object {
        const val CHANNEL_ID = "pump_timer_channel"
        const val NOTIF_ID = 1010
    }
}