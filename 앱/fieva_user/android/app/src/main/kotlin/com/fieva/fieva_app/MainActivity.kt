package com.fieva.fieva_app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import android.view.KeyEvent
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var accessibilityChannel: MethodChannel? = null
    private var emergencyChannel: MethodChannel? = null
    private var emergencyPlayer: MediaPlayer? = null
    private val emergencyHandler = Handler(Looper.getMainLooper())
    private var emergencyVibrating = false
    private var pendingVolumeUp = false
    private var pendingEmergencyLaunch = false
    private val emergencyVibrationRunnable = object : Runnable {
        override fun run() {
            if (!emergencyVibrating) return
            vibrate("strong")
            emergencyHandler.postDelayed(this, 1500L)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        keepVisibleForEmergency()
        pendingVolumeUp = isVolumeUpIntent(intent)
        pendingEmergencyLaunch = isEmergencyIntent(intent)
        EmergencyAlertLauncher.createChannel(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        accessibilityChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "fieva/accessibility_controls"
        )
        accessibilityChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isBluetoothEnabled" -> result.success(isBluetoothEnabled())
                "openBluetoothSettings" -> {
                    openBluetoothSettings()
                    result.success(null)
                }
                "vibrate" -> {
                    val style = call.argument<String>("style") ?: "medium"
                    result.success(vibrate(style))
                }
                else -> result.notImplemented()
            }
        }
        emergencyChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "fieva/emergency_alert"
        )
        emergencyChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startEmergencyAlert" -> result.success(startEmergencyAlert())
                "stopEmergencyAlert" -> result.success(stopEmergencyAlert())
                "consumeEmergencyLaunch" -> result.success(consumeEmergencyLaunch())
                else -> result.notImplemented()
            }
        }
        dispatchPendingVolumeUp()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        keepVisibleForEmergency()
        if (isEmergencyIntent(intent)) {
            pendingEmergencyLaunch = true
        }
        if (isVolumeUpIntent(intent)) {
            pendingVolumeUp = true
            dispatchPendingVolumeUp()
        }
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            dispatchVolumeUp()
            return true
        }
        return super.onKeyUp(keyCode, event)
    }

    override fun onDestroy() {
        stopEmergencyAlarmSound()
        stopEmergencyVibration()
        super.onDestroy()
    }

    private fun isVolumeUpIntent(intent: Intent?): Boolean {
        return intent?.action == ACTION_VOLUME_UP ||
            intent?.getBooleanExtra(EXTRA_VOLUME_UP, false) == true
    }

    private fun isEmergencyIntent(intent: Intent?): Boolean {
        return intent?.action == ACTION_EMERGENCY_ALERT ||
            intent?.getBooleanExtra(EXTRA_EMERGENCY_ALERT, false) == true
    }

    private fun consumeEmergencyLaunch(): Boolean {
        val value = pendingEmergencyLaunch || isEmergencyIntent(intent)
        pendingEmergencyLaunch = false
        intent?.removeExtra(EXTRA_EMERGENCY_ALERT)
        return value
    }

    private fun dispatchPendingVolumeUp() {
        if (!pendingVolumeUp) return
        pendingVolumeUp = false
        dispatchVolumeUp()
    }

    private fun dispatchVolumeUp() {
        val channel = accessibilityChannel
        if (channel == null) {
            pendingVolumeUp = true
            return
        }
        channel.invokeMethod("volumeUp", null)
    }

    private fun startEmergencyAlert(): Boolean {
        EmergencyAlertLauncher.createChannel(this)
        EmergencyAlertLauncher.showNotification(this)
        EmergencyAlertLauncher.launchActivity(this)
        return true
    }

    private fun stopEmergencyAlert(): Boolean {
        stopEmergencyAlarmSound()
        stopEmergencyVibration()
        EmergencyAlertLauncher.cancel(this)
        return true
    }

    private fun startEmergencyAlarmSound() {
        if (emergencyPlayer?.isPlaying == true) return
        stopEmergencyAlarmSound()
        val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            ?: return
        emergencyPlayer = try {
            MediaPlayer().apply {
                setDataSource(applicationContext, alarmUri)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                } else {
                    @Suppress("DEPRECATION")
                    setAudioStreamType(android.media.AudioManager.STREAM_ALARM)
                }
                isLooping = true
                prepare()
                start()
            }
        } catch (_: Throwable) {
            null
        }
    }

    private fun stopEmergencyAlarmSound() {
        val player = emergencyPlayer ?: return
        try {
            if (player.isPlaying) player.stop()
        } catch (_: Throwable) {
        } finally {
            try {
                player.release()
            } catch (_: Throwable) {
            }
            emergencyPlayer = null
        }
    }

    private fun startEmergencyVibration() {
        if (emergencyVibrating) return
        emergencyVibrating = true
        emergencyHandler.removeCallbacks(emergencyVibrationRunnable)
        emergencyHandler.post(emergencyVibrationRunnable)
    }

    private fun stopEmergencyVibration() {
        emergencyVibrating = false
        emergencyHandler.removeCallbacks(emergencyVibrationRunnable)
    }

    private fun keepVisibleForEmergency() {
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }

    private fun isBluetoothEnabled(): Boolean {
        return try {
            val adapter = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val manager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                manager.adapter
            } else {
                @Suppress("DEPRECATION")
                BluetoothAdapter.getDefaultAdapter()
            }
            adapter?.isEnabled == true
        } catch (_: SecurityException) {
            false
        }
    }

    private fun openBluetoothSettings() {
        val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }

    private fun vibrate(style: String): Boolean {
        val vibrator = try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val manager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                manager.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }
        } catch (_: Throwable) {
            return false
        }
        if (!vibrator.hasVibrator()) return false

        val effect = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            when (style) {
                "strong" -> VibrationEffect.createWaveform(
                    longArrayOf(0L, 240L, 90L, 240L, 90L, 360L),
                    intArrayOf(0, 255, 0, 255, 0, 255),
                    -1
                )
                "medium" -> VibrationEffect.createWaveform(
                    longArrayOf(0L, 140L, 80L, 180L),
                    intArrayOf(0, 210, 0, 210),
                    -1
                )
                else -> VibrationEffect.createOneShot(90L, 160)
            }
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(if (style == "strong") 700L else 250L)
            return true
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val attrs = VibrationAttributes.Builder()
                .setUsage(VibrationAttributes.USAGE_ACCESSIBILITY)
                .build()
            vibrator.vibrate(effect, attrs)
        } else {
            vibrator.vibrate(effect)
        }
        return true
    }

    companion object {
        const val ACTION_VOLUME_UP = "com.fieva.VOLUME_UP"
        const val ACTION_EMERGENCY_ALERT = "com.fieva.EMERGENCY_ALERT"
        const val EXTRA_VOLUME_UP = "fieva_volume_up"
        const val EXTRA_EMERGENCY_ALERT = "fieva_emergency_alert"
    }
}
