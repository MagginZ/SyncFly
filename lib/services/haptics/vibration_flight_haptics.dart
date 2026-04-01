import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vibration/vibration.dart';

import '../../domain/flight/flight_phase.dart';

/// 使用 [vibration] 包按飞行阶段提供振动；[hapticIntensity] 缩放时长/幅度。
///
/// Web 无振动马达，全部 no-op。
class VibrationFlightHaptics {
  VibrationFlightHaptics._();

  static Future<void> stop() async {
    if (kIsWeb) return;
    try {
      await Vibration.cancel();
    } catch (_) {}
  }

  static int _scaleMs(int ms, double intensityMul) {
    return (ms * intensityMul.clamp(0.05, 1.5)).round().clamp(20, 5000);
  }

  static List<int> _scalePattern(List<int> pattern, double intensityMul) {
    return pattern.map((e) => _scaleMs(e, intensityMul)).toList();
  }

  static bool isTakeoffToLiftoff(FlightPhase prev, FlightPhase next) {
    final was = prev.maybeMap(
      takeoffAcceleration: (_) => true,
      orElse: () => false,
    );
    final now = next.maybeMap(
      liftoffClimb: (_) => true,
      orElse: () => false,
    );
    return was && now;
  }

  static bool isDescentToIdle(FlightPhase prev, FlightPhase next) {
    final was = prev.maybeMap(descent: (_) => true, orElse: () => false);
    final now = next.maybeMap(idle: (_) => true, orElse: () => false);
    return was && now;
  }

  /// 抬轮瞬间：短促高强度。
  static Future<void> playRotationPulse(double hapticIntensity) async {
    if (kIsWeb) return;
    if (!await Vibration.hasVibrator()) return;
    await Vibration.cancel();
    final d = _scaleMs(150, hapticIntensity);
    final hasAmp = await Vibration.hasAmplitudeControl();
    if (hasAmp) {
      final amp = (80 + 175 * hapticIntensity.clamp(0.0, 1.0)).round().clamp(1, 255);
      await Vibration.vibrate(duration: d, amplitude: amp);
    } else {
      await Vibration.vibrate(duration: d);
    }
  }

  /// 接地感：两次短振。
  static Future<void> playTouchdownPulse(double hapticIntensity) async {
    if (kIsWeb) return;
    if (!await Vibration.hasVibrator()) return;
    await Vibration.cancel();
    final custom = await Vibration.hasCustomVibrationsSupport();
    if (custom) {
      await Vibration.vibrate(
        pattern: _scalePattern([0, 100, 100, 100], hapticIntensity),
        repeat: -1,
      );
    } else {
      await Vibration.vibrate(duration: _scaleMs(100, hapticIntensity));
    }
  }

  /// 当前阶段持续/循环振动（触觉会话开启时调用）。
  static Future<void> applySustainedPhasePattern(
    FlightPhase phase,
    double hapticIntensity,
  ) async {
    if (kIsWeb) return;
    if (hapticIntensity < 0.05) {
      await stop();
      return;
    }
    if (!await Vibration.hasVibrator()) return;

    await Vibration.cancel();
    final m = hapticIntensity.clamp(0.05, 1.5);
    final custom = await Vibration.hasCustomVibrationsSupport();

    await phase.when(
      idle: () async {
        await stop();
      },
      taxiing: () async {
        if (custom) {
          await Vibration.vibrate(
            pattern: _scalePattern([0, 180, 220, 160], m),
            repeat: 0,
          );
        } else {
          await Vibration.vibrate(duration: _scaleMs(200, m));
        }
      },
      takeoffAcceleration: () async {
        if (custom) {
          await Vibration.vibrate(
            pattern: _scalePattern([0, 650, 200, 520], m),
            repeat: 0,
          );
        } else {
          await Vibration.vibrate(duration: _scaleMs(600, m));
        }
      },
      liftoffClimb: () async {
        if (custom) {
          // 持续低强度循环：振 2s → 停 0.5s，从 pattern 起点重复
          await Vibration.vibrate(
            pattern: _scalePattern([0, 2000, 500], m),
            repeat: 0,
          );
        } else {
          await Vibration.vibrate(duration: _scaleMs(2000, m));
        }
      },
      cruising: () async {
        await stop();
      },
      descent: () async {
        if (custom) {
          await Vibration.vibrate(
            pattern: _scalePattern([0, 130, 110, 130, 110, 130], m),
            repeat: 0,
          );
        } else {
          await Vibration.vibrate(duration: _scaleMs(250, m));
        }
      },
    );
  }
}
