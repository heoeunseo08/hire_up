package com.example.hire_up

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.provider.Telephony
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.jar.Manifest

class MainActivity : FlutterActivity() {

    private val SMSCHANNEL = "sms";
    private var smsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.RECEIVE_SMS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    android.Manifest.permission.RECEIVE_SMS,
                    android.Manifest.permission.READ_SMS
                ), 100
            )
        }

        val smsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMSCHANNEL);

        smsChannel.setMethodCallHandler { call, result ->
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
            override fun onReceive(p0: Context?, p1: Intent?) {
                Log.d("sms", "sms 수신")
                val message = Telephony.Sms.Intents.getMessagesFromIntent(p1)
                Log.d("sms", "메세지 수: ${message?.size}")
                for (msg in message) {
                    val body = msg.messageBody
                    Log.d("sms", "본문: ${body}")
                    val match = Regex("""\[(\d+)]""").find(body)
                    Log.d("sms", "결과: ${match}")
                    if (match != null) {
                        val code = match.groupValues[1];
                        Log.d("sms", "인증번호: ${code}")
                        smsChannel.invokeMethod("smsRead", code);
                    }
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
