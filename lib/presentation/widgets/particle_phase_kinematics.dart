import '../../domain/flight/flight_phase.dart';

/// 粒子场运动学：仅由 [FlightPhase] 决定方向与相对强度，再乘用户「动画速率」。
/// 与调参混合解耦，避免阶段切换时方向含糊。
class ParticlePhaseKinematics {
  const ParticlePhaseKinematics({
    required this.fx,
    required this.fy,
    required this.driftStrength,
    required this.orbitFrequencyMul,
  });

  /// 未归一化的漂移方向（屏幕坐标：右 +X，下 +Y）。
  final double fx;
  final double fy;

  /// 相对漂移强度 [0,1]，与动画速率相乘得像素级速度。
  final double driftStrength;

  /// 相对轨道角速度，与动画速率、呼吸脉动相乘。
  final double orbitFrequencyMul;
}

/// 规则：滑行柔和向下；加速推背更快向下；拉起向下+向后；失重向上漂浮。
ParticlePhaseKinematics particleKinematicsForPhase(FlightPhase phase) {
  return phase.when(
    idle: () => const ParticlePhaseKinematics(
      fx: 0,
      fy: 1,
      driftStrength: 0.12,
      orbitFrequencyMul: 0.3,
    ),
    taxiing: () => const ParticlePhaseKinematics(
      fx: 0,
      fy: 1,
      driftStrength: 0.4,
      orbitFrequencyMul: 0.45,
    ),
    takeoffAcceleration: () => const ParticlePhaseKinematics(
      fx: 0,
      fy: 1,
      driftStrength: 0.9,
      orbitFrequencyMul: 0.98,
    ),
    liftoffClimb: () => const ParticlePhaseKinematics(
      fx: -0.42,
      fy: 0.91,
      driftStrength: 0.76,
      orbitFrequencyMul: 0.84,
    ),
    cruising: () => const ParticlePhaseKinematics(
      fx: 0,
      fy: 0.2,
      driftStrength: 0.14,
      orbitFrequencyMul: 0.24,
    ),
    descent: () => const ParticlePhaseKinematics(
      fx: 0,
      fy: -1,
      driftStrength: 0.62,
      orbitFrequencyMul: 0.46,
    ),
  );
}
