package com.example.flutter_platform_channels_sample

import android.os.Bundle
import android.os.Handler
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.nio.ByteBuffer
import java.nio.ByteOrder

class MainActivity : FlutterActivity() {
    private var TAG = MainActivity::class.java.simpleName

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Start receiving messages from flutter
        this.startReceivingMessagesFromFlutter()

        // Send message to flutter
        this.sendMessageToFlutter()
    }

    private fun startReceivingMessagesFromFlutter() {
        flutterView.setMessageHandler("flutter_to_native_binary_message" ) { message, reply ->
            message.order(ByteOrder.nativeOrder())
            val x = message.double
            val y = message.int
            Log.d(TAG, "Received $x and $y")
            reply.reply(null)
        }
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
