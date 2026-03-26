import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/flight_session_controller.dart';
import 'platform/haptic_platform.dart';

/// 以固定节拍采样呼吸包络，驱动渐进式触觉（避免每帧调用）。
class HapticScheduler {
  HapticScheduler(this._platform);

  final HapticPlatform _platform;
  Timer? _timer;
  WidgetRef? _ref;
  double _intensityMul = 1;

  void start(WidgetRef ref, {double intensityMul = 1}) {
    _ref = ref;
    _intensityMul = intensityMul;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 88), (_) => _tick());
  }

  void updateIntensity(double mul) {
    _intensityMul = mul;
  }

  Future<void> _tick() async {
    final r = _ref;
    if (r == null || !r.context.mounted) return;

    final tuning = r.read(flightSessionProvider).tuning;
    final elapsed = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final breath = math.sin(2 * math.pi * tuning.breathHz * elapsed);
    final env = 0.35 + 0.65 * (0.5 + 0.5 * breath);
    final base = (env * _intensityMul).clamp(0.0, 1.0);

    if (tuning.flowSpeed < 0.05 && tuning.breathAmplitude < 0.03) {
      return;
    }

    final amp = (base * 255).round().clamp(1, 255);
    final ampSoft = (amp * 0.55).round().clamp(1, 255);

    await _platform.playWaveform(
      timingsMs: [0, 22, 56, 18],
      amplitudes: [amp, ampSoft],
    );
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _ref = null;
    await _platform.stop();
  }
}
