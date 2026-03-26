import 'dart:math' as math;

import '../../domain/flight/breath_pattern_kind.dart';
import '../../domain/flight/flight_visual_tuning.dart';

/// 归一化呼吸相位 [0,1]，用于扩张/收缩与触觉包络。
double breathEnvelope01(double timeSec, FlightVisualTuning tuning) {
  switch (tuning.breathPattern) {
    case BreathPatternKind.smoothSine:
      return (0.5 +
              0.5 * math.sin(2 * math.pi * tuning.breathHz * timeSec))
          .clamp(0.0, 1.0);
    case BreathPatternKind.fourSevenEight:
      return _envelope478(timeSec);
  }
}

/// 4-7-8：0–4 吸气，4–11 屏息，11–19 呼气。
double _envelope478(double timeSec) {
  const cycle = 19.0;
  final p = timeSec % cycle;
  if (p < 4) return p / 4;
  if (p < 11) return 1;
  return (1 - (p - 11) / 8).clamp(0.0, 1.0);
}

/// 粒子半径缩放：吸气扩张、呼气收缩。
double breathParticleScale(double timeSec, FlightVisualTuning tuning) {
  final e = breathEnvelope01(timeSec, tuning);
  return 0.38 + 0.62 * e;
}

/// 不透明度调制。
double breathOpacityFactor(double timeSec, FlightVisualTuning tuning) {
  final e = breathEnvelope01(timeSec, tuning);
  return 0.55 + 0.45 * e;
}
