package com.example.flutter_platform_channels_sample

import android.os.Bundle
import android.os.Handler
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.nio.ByteBuffer

class MainActivity : FlutterActivity() {
    private var TAG = MainActivity::class.java.simpleName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Send message to flutter
        this.sendMessageToFlutter()
    }

    private fun sendMessageToFlutter() {
        val message = ByteBuffer.allocateDirect(12)
        message.putDouble(3.1415)
        message.putInt(123456789)

        Handler().postDelayed({
            flutterView.send("native_to_flutter_binary_message", message) {
                Log.d(TAG, "Message sent!")
            }
        }, 2000)
    }
}
