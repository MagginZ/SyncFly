package com.vestibular.SyncFly

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "app/haptics"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "playTransient" -> {
                    val intensity = (call.argument<Double>("intensity") ?: 0.5).coerceIn(0.0, 1.0)
                    val amp = (1 + intensity * 254).toInt()
                    playWaveform(listOf(0, 28), listOf(amp), result)
                }
                "playWaveform" -> {
                    val timings = call.argument<List<Int>>("timings") ?: emptyList()
                    val amplitudes = call.argument<List<Int>>("amplitudes") ?: emptyList()
                    if (timings.isEmpty()) {
                        result.error("bad_args", "timings empty", null)
                        return@setMethodCallHandler
                    }
                    playWaveform(timings, amplitudes, result)
                }
                "stop" -> {
                    vibrator()?.cancel()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun vibrator(): Vibrator? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vm.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(VIBRATOR_SERVICE) as Vibrator
        }
    }

    private fun playWaveform(timings: List<Int>, amplitudes: List<Int>, result: MethodChannel.Result) {
        val v = vibrator()
        if (v == null || !v.hasVibrator()) {
            result.success(null)
            return
        }
        val longTimings = timings.map { it.toLong() }.toLongArray()
        val onCount = timings.indices.count { it % 2 == 1 }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val amps = IntArray(onCount.coerceAtLeast(1)) { idx ->
                val raw = if (idx < amplitudes.size) amplitudes[idx] else amplitudes.lastOrNull() ?: 220
                raw.coerceIn(1, 255)
            }
            try {
                val effect = VibrationEffect.createWaveform(longTimings, amps, -1)
                v.vibrate(effect)
            } catch (_: Exception) {
                @Suppress("DEPRECATION")
                v.vibrate(longTimings, -1)
            }
        } else {
            @Suppress("DEPRECATION")
            v.vibrate(longTimings, -1)
        }
        result.success(null)
    }
}
