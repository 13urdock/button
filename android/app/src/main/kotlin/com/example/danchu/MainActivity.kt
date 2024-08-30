package com.example.danchu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.media.AudioManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourcompany.yourapp/system_settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateSystemSettings") {
                val sound = call.argument<Boolean>("sound")
                val vibration = call.argument<Boolean>("vibration")
                updateSystemSettings(sound, vibration)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateSystemSettings(sound: Boolean?, vibration: Boolean?) {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        sound?.let {
            audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION,
                if (it) audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION) else 0,
                0)
        }
        vibration?.let {
            audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION,
                if (it) 1 else 0,
                AudioManager.FLAG_VIBRATE)
        }
    }
}