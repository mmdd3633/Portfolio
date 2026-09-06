package com.fieva.fieva_app

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FievaFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        if (isFireAlert(message)) {
            EmergencyAlertLauncher.start(this)
        }
    }

    private fun isFireAlert(message: RemoteMessage): Boolean {
        val haystack = buildString {
            append(message.notification?.title.orEmpty())
            append(' ')
            append(message.notification?.body.orEmpty())
            for ((key, value) in message.data) {
                append(' ')
                append(key)
                append('=')
                append(value)
            }
        }.lowercase()

        return haystack.contains("fire") ||
            haystack.contains("emergency") ||
            haystack.contains("alert") ||
            haystack.contains("화재") ||
            haystack.contains("경보")
    }
}
