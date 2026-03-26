import '../settings/session_settings.dart';
import 'flight_phase.dart';
import 'flight_visual_tuning.dart';

FlightVisualTuning tuningForPhase(FlightPhase phase, SessionSettings s) {
  final rate = s.animationRate;
  return phase.when(
    idle: () => FlightVisualTuning(
      flowDirectionX: 0,
      flowDirectionY: 0.15,
      flowSpeed: 0.15 * rate,
      breathAmplitude: 0.06,
      breathHz: 0.2 * rate,
      particleJitter: 0.02,
      guidanceText: '放松肩背，跟随屏幕缓慢呼吸',
      guidanceVisible: true,
    ),
    taxiing: () => FlightVisualTuning(
      flowDirectionX: -0.08,
      flowDirectionY: 0.25 * rate,
      flowSpeed: 0.35 * rate,
      breathAmplitude: 0.07,
      breathHz: 0.18 * rate,
      particleJitter: 0.03,
      guidanceText: '身体微微后靠，目光落在柔和的运动上',
      guidanceVisible: true,
    ),
    takeoffAcceleration: () => FlightVisualTuning(
      flowDirectionX: -0.12,
      flowDirectionY: 0.85 * rate,
      flowSpeed: 0.75 * rate,
      breathAmplitude: 0.09,
      breathHz: 0.22 * rate,
      particleJitter: 0.04,
      guidanceText: '请将身体微微后靠',
      guidanceVisible: true,
    ),
    liftoffClimb: () => FlightVisualTuning(
      flowDirectionX: -0.06,
      flowDirectionY: 0.65 * rate,
      flowSpeed: 0.55 * rate,
      breathAmplitude: 0.12,
      breathHz: 0.17 * rate,
      particleJitter: 0.05,
      guidanceText: '鼻吸口呼，像机翼平稳爬升',
      guidanceVisible: true,
    ),
    levelOff: () => FlightVisualTuning(
      flowDirectionX: 0,
      flowDirectionY: 0.1 * rate,
      flowSpeed: 0.25 * rate,
      breathAmplitude: 0.05,
      breathHz: 0.14 * rate,
      particleJitter: 0.02,
      guidanceText: '已平飞，可以闭眼休息片刻',
      guidanceVisible: true,
    ),
  );
}
