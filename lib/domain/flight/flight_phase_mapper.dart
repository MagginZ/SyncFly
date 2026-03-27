import 'breath_pattern_kind.dart';
import '../settings/session_settings.dart';
import 'flight_phase.dart';
import 'flight_visual_tuning.dart';

FlightVisualTuning tuningForPhase(FlightPhase phase, SessionSettings s) {
  final rate = s.animationRate;
  return phase.when(
    idle: () => FlightVisualTuning(
      flowDirectionX: 0,
      flowDirectionY: 0.14,
      flowSpeed: 0.12 * rate,
      breathAmplitude: 0.06,
      breathHz: 0.12 * rate,
      particleJitter: 0.02,
      guidanceText: '放松肩背，跟随屏幕缓慢呼吸',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.smoothSine,
      hapticGain: 0.35,
    ),
    taxiing: () => FlightVisualTuning(
      flowDirectionX: -0.12,
      flowDirectionY: 0.42,
      flowSpeed: 0.42 * rate,
      breathAmplitude: 0.08,
      breathHz: 0.14 * rate,
      particleJitter: 0.035,
      guidanceText: '滑行：身体微微后靠，目光落在柔和的运动上，点击「加速推背」进入下一阶段',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.fourSevenEight,
      hapticGain: 0.65,
    ),
    takeoffAcceleration: () => FlightVisualTuning(
      flowDirectionX: -0.26,
      flowDirectionY: 0.95,
      flowSpeed: 0.82 * rate,
      breathAmplitude: 0.1,
      breathHz: 0.16 * rate,
      particleJitter: 0.045,
      guidanceText: '加速推背：请将身体微微后靠，点击「拉起爬升」进入下一阶段',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.fourSevenEight,
      hapticGain: 0.92,
    ),
    liftoffClimb: () => FlightVisualTuning(
      flowDirectionX: -0.2,
      flowDirectionY: 0.82,
      flowSpeed: 0.68 * rate,
      breathAmplitude: 0.11,
      breathHz: 0.15 * rate,
      particleJitter: 0.048,
      guidanceText: '拉起爬升：鼻吸口呼，像机翼平稳爬升， 若已感觉平稳，请点击「进入平飞」',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.fourSevenEight,
      hapticGain: 0.78,
    ),
    
    cruising: () => FlightVisualTuning(
      flowDirectionX: -0.03,
      flowDirectionY: 0.07,
      flowSpeed: 0.14 * rate,
      breathAmplitude: 0.05,
      breathHz: 0.1 * rate,
      particleJitter: 0.02,
      guidanceText: '已平飞，可以闭眼休息片刻。需要下降时请点「开始下降」',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.smoothSine,
      hapticGain: 0.25,
    ),
    descent: () => FlightVisualTuning(
      flowDirectionX: -0.1,
      flowDirectionY: -0.72,
      flowSpeed: 0.58 * rate,
      breathAmplitude: 0.1,
      breathHz: 0.13 * rate,
      particleJitter: 0.042,
      guidanceText: '下降/失重，跟随柔和深呼吸',
      guidanceVisible: true,
      breathPattern: BreathPatternKind.fourSevenEight,
      hapticGain: 0.72,
    ),
  );
}
