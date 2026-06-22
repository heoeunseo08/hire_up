package com.example.hire_up

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val smsChannelName = "sms"
    private var smsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val smsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, smsChannelName)

        smsChannel.setMethodCallHandler { call, _ ->
            if (call.method == "checkPermission") {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(
                        android.Manifest.permission.RECEIVE_SMS,
                        android.Manifest.permission.READ_SMS
                    ),
                    100
                )
            }
        }

        smsReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent) ?: return
                for (msg in messages) {
                    val match = Regex("""\[(\d+)]""").find(msg.messageBody) ?: continue
                    smsChannel.invokeMethod("smsRead", match.groupValues[1])
                }
            }
        }

        val filter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        registerReceiver(smsReceiver, filter)
    }

    override fun onDestroy() {
        super.onDestroy()
        smsReceiver?.let { unregisterReceiver(it) }
    }
}
