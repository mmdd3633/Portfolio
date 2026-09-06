package com.fieva.fieva_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager

object EmergencyAlertLauncher {
    const val CHANNEL_ID = "fieva_emergency_silent"
    private const val LEGACY_CHANNEL_ID = "fieva_emergency"
    private const val CHANNEL_NAME = "Fieva emergency alerts"
    const val NOTIFICATION_ID = 70801

    fun start(context: Context) {
        wakeScreen(context)
        createChannel(context)
        showNotification(context)
        launchActivity(context)
    }

    fun cancel(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(NOTIFICATION_ID)
    }

    fun createChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createSilentChannel(manager, LEGACY_CHANNEL_ID)
        createSilentChannel(manager, CHANNEL_ID)
    }

    private fun createSilentChannel(manager: NotificationManager, channelId: String) {
        val existing = manager.getNotificationChannel(channelId)
        if (existing != null &&
            (existing.sound != null || existing.shouldVibrate())
        ) {
            manager.deleteNotificationChannel(channelId)
        }

        val channel = NotificationChannel(
            channelId,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Fire and evacuation alerts"
            enableVibration(false)
            setSound(null, null)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }

        manager.createNotificationChannel(channel)
    }

    fun showNotification(context: Context) {
        val intent = emergencyIntent(context)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0
        val pendingIntent = PendingIntent.getActivity(
            context,
            NOTIFICATION_ID,
            intent,
            flags
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }
        val notification = builder
            .setSmallIcon(context.applicationInfo.icon)
            .setContentTitle("화재 경보")
            .setContentText("가까운 비상구로 이동하세요. 대피 지도를 엽니다.")
            .setCategory(Notification.CATEGORY_ALARM)
            .setPriority(Notification.PRIORITY_MAX)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setDefaults(0)
            .setSound(null)
            .setVibrate(longArrayOf(0L))
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .setAutoCancel(false)
            .setContentIntent(pendingIntent)
            .setFullScreenIntent(pendingIntent, true)
            .build()
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, notification)
    }

    fun launchActivity(context: Context) {
        try {
            context.startActivity(emergencyIntent(context))
        } catch (_: Throwable) {
        }
    }

    private fun wakeScreen(context: Context) {
        try {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            @Suppress("DEPRECATION")
            val wakeLock = powerManager.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                    PowerManager.ACQUIRE_CAUSES_WAKEUP or
                    PowerManager.ON_AFTER_RELEASE,
                "Fieva:FireAlarmWakeLock"
            )
            wakeLock.acquire(10_000L)
        } catch (_: Throwable) {
        }
    }

    private fun emergencyIntent(context: Context): Intent {
        return Intent(context, MainActivity::class.java).apply {
            action = MainActivity.ACTION_EMERGENCY_ALERT
            putExtra(MainActivity.EXTRA_EMERGENCY_ALERT, true)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
    }
}
