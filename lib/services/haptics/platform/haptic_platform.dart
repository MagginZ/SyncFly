import 'package:flutter/services.dart';

import '../../../platform/channels.dart';

abstract class HapticPlatform {
  Future<void> playTransient({
    required double intensity,
    required double sharpness,
  });

  Future<void> playWaveform({
    required List<int> timingsMs,
    required List<int> amplitudes,
  });

  Future<void> stop();
}

class MethodChannelHapticPlatform implements HapticPlatform {
  MethodChannelHapticPlatform()
      : _channel = MethodChannel(AppChannels.haptics);

  final MethodChannel _channel;

  @override
  Future<void> playTransient({
    required double intensity,
    required double sharpness,
  }) async {
    try {
      await _channel.invokeMethod<void>('playTransient', {
        'intensity': intensity,
        'sharpness': sharpness,
      });
    } on PlatformException {
      /* 模拟器或未实现通道 */
    }
  }

  @override
  Future<void> playWaveform({
    required List<int> timingsMs,
    required List<int> amplitudes,
  }) async {
    try {
      await _channel.invokeMethod<void>('playWaveform', {
        'timings': timingsMs,
        'amplitudes': amplitudes,
      });
    } on PlatformException {
      /* fallback 静默 */
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      /* */
    }
  }
}
