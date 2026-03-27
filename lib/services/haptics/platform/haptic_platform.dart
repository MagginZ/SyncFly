import 'package:flutter/foundation.dart' show kIsWeb;
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

/// Web / 无原生实现时使用，避免 MissingPluginException 打断交互。
class NoOpHapticPlatform implements HapticPlatform {
  const NoOpHapticPlatform();

  @override
  Future<void> playTransient({
    required double intensity,
    required double sharpness,
  }) async {}

  @override
  Future<void> playWaveform({
    required List<int> timingsMs,
    required List<int> amplitudes,
  }) async {}

  @override
  Future<void> stop() async {}
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
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('playTransient', {
        'intensity': intensity,
        'sharpness': sharpness,
      });
    } on MissingPluginException {
      /* Web 等无 MethodChannel 实现 */
    } on PlatformException {
      /* 模拟器或未实现通道 */
    }
  }

  @override
  Future<void> playWaveform({
    required List<int> timingsMs,
    required List<int> amplitudes,
  }) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('playWaveform', {
        'timings': timingsMs,
        'amplitudes': amplitudes,
      });
    } on MissingPluginException {
      /* Web 等 */
    } on PlatformException {
      /* fallback 静默 */
    }
  }

  @override
  Future<void> stop() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('stop');
    } on MissingPluginException {
      /* Web 等 */
    } on PlatformException {
      /* */
    }
  }
}
