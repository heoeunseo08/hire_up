package com.example.hire_up

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.media.audiofx.Visualizer
import android.os.Build
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val smsChannelName = "sms"
    private val audioChannelName = "audio"
    private var smsReceiver: BroadcastReceiver? = null

    private var mediaPlayer: MediaPlayer? = null
    private var mediaRecorder: MediaRecorder? = null
    private var recordingPath: String? = null
    private var visualizer: Visualizer? = null
    private var isAudioCompleted = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ─── SMS 채널 (기존) ───────────────────────────────────────────
        val smsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, smsChannelName)
        val audioChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, audioChannelName)

        smsChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(
                            android.Manifest.permission.RECEIVE_SMS,
                            android.Manifest.permission.READ_SMS
                        ),
                        100
                    )
                }

                "share" -> {
                    val text = call.argument<String>("text") ?: ""
                    val intent = Intent(Intent.ACTION_SEND).apply {
                        type = "text/plain"
                        putExtra(Intent.EXTRA_TEXT, text)
                    }
                    startActivity(Intent.createChooser(intent, "채용정보 공유"))
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }

        audioChannel.setMethodCallHandler { call, result ->
            when (call.method) {

                "start" -> {
                    val url = call.argument<String>("url")
                    isAudioCompleted = false
                    visualizer?.release()
                    visualizer = null
                    mediaPlayer?.release()
                    mediaPlayer = MediaPlayer().apply {
                        setDataSource(url)
                        prepare()
                        start()
                        // 재생 완료 감지
                        setOnCompletionListener {
                            isAudioCompleted = true
                        }
                        // Visualizer 연결 (진폭 측정용)
                        try {
                            visualizer = Visualizer(audioSessionId).apply {
                                captureSize = Visualizer.getCaptureSizeRange()[0]
                                enabled = true
                            }
                        } catch (e: Exception) {
                            // Visualizer 실패 시 무시
                        }
                    }
                    result.success(true)
                }

                "play" -> {
                    mediaPlayer?.start()
                    result.success(true)
                }

                "stop" -> {
                    mediaPlayer?.pause()
                    result.success(true)
                }

                "end" -> {
                    visualizer?.release()
                    visualizer = null
                    mediaPlayer?.stop()
                    mediaPlayer?.release()
                    mediaPlayer = null
                    isAudioCompleted = false
                    result.success(true)
                }

                "currentTime" -> {
                    result.success(mediaPlayer?.currentPosition ?: 0)
                }

                // 재생 완료 여부 (OnCompletionListener 기반)
                "isCompleted" -> {
                    result.success(isAudioCompleted)
                    isAudioCompleted = false // 읽은 후 초기화
                }

                // 실시간 진폭 (0~128)
                "getAmplitude" -> {
                    try {
                        val waveform = ByteArray(Visualizer.getCaptureSizeRange()[0])
                        visualizer?.getWaveForm(waveform)
                        val amplitude = waveform.maxOfOrNull { (it.toInt() and 0xFF) - 128 }
                            ?.coerceAtLeast(0) ?: 0
                        result.success(amplitude)
                    } catch (e: Exception) {
                        result.success(0)
                    }
                }

                "recode_start" -> {
                    val path = call.argument<String>("path")!!
                    try {
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                            if (checkSelfPermission(android.Manifest.permission.RECORD_AUDIO)
                                != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                                requestPermissions(arrayOf(android.Manifest.permission.RECORD_AUDIO), 101)
                                result.success(false)
                                return@setMethodCallHandler
                            }
                        }
                        mediaRecorder?.release()
                        mediaRecorder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                            MediaRecorder(this) else MediaRecorder()
                        mediaRecorder!!.apply {
                            setAudioSource(MediaRecorder.AudioSource.MIC)
                            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                            setOutputFile(path)
                            prepare()
                            start()
                        }
                        recordingPath = path
                        result.success(true)
                    } catch (e: Exception) {
                        mediaRecorder?.release()
                        mediaRecorder = null
                        result.success(false)
                    }
                }

                "recode_stop" -> {
                    try {
                        mediaRecorder?.stop()
                    } catch (e: Exception) { }
                    mediaRecorder?.release()
                    mediaRecorder = null
                    result.success(recordingPath)
                }

                else -> result.notImplemented()
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
        visualizer?.release()
        mediaPlayer?.release()
        mediaRecorder?.release()
    }
}
