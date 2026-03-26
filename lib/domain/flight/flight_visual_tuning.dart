import '../../core/utils/lerp_utils.dart';
import 'breath_pattern_kind.dart';

/// 已由状态机混合后的连续参数，供绘制与触觉读取。
class FlightVisualTuning {
  const FlightVisualTuning({
    required this.flowDirectionX,
    required this.flowDirectionY,
    required this.flowSpeed,
    required this.breathAmplitude,
    required this.breathHz,
    required this.particleJitter,
    required this.guidanceText,
    required this.guidanceVisible,
    this.breathPattern = BreathPatternKind.smoothSine,
    this.hapticGain = 1,
  });

  /// 屏幕坐标系：向右为正；负值表示「向后」趋势。
  final double flowDirectionX;

  /// 向下为正；起飞拉起为后下方向（正 Y、负 X）；降落失重为向上漂浮（负 Y）。
  final double flowDirectionY;
  final double flowSpeed;
  final double breathAmplitude;
  final double breathHz;
  final double particleJitter;
  final String guidanceText;
  final bool guidanceVisible;

  /// 呼吸节律形态（与 [breathHz] 在 smooth 模式下共同作用）。
  final BreathPatternKind breathPattern;

  /// 当前阶段触觉相对强度 [0,1]。
  final double hapticGain;

  FlightVisualTuning lerp(FlightVisualTuning b, double t) {
    final x = lerpDouble(flowDirectionX, b.flowDirectionX, t);
    final y = lerpDouble(flowDirectionY, b.flowDirectionY, t);
    final s = lerpDouble(flowSpeed, b.flowSpeed, t);
    final ba = lerpDouble(breathAmplitude, b.breathAmplitude, t);
    final bh = lerpDouble(breathHz, b.breathHz, t);
    final pj = lerpDouble(particleJitter, b.particleJitter, t);
    final hg = lerpDouble(hapticGain, b.hapticGain, t);
    return FlightVisualTuning(
      flowDirectionX: x,
      flowDirectionY: y,
      flowSpeed: s,
      breathAmplitude: ba,
      breathHz: bh,
      particleJitter: pj,
      guidanceText: t < 0.5 ? guidanceText : b.guidanceText,
      guidanceVisible: t < 0.5 ? guidanceVisible : b.guidanceVisible,
      breathPattern: t < 0.5 ? breathPattern : b.breathPattern,
      hapticGain: hg,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightVisualTuning &&
          other.flowDirectionX == flowDirectionX &&
          other.flowDirectionY == flowDirectionY &&
          other.flowSpeed == flowSpeed &&
          other.breathAmplitude == breathAmplitude &&
          other.breathHz == breathHz &&
          other.particleJitter == particleJitter &&
          other.guidanceText == guidanceText &&
          other.guidanceVisible == guidanceVisible &&
          other.breathPattern == breathPattern &&
          other.hapticGain == hapticGain;

  @override
  int get hashCode => Object.hash(
        flowDirectionX,
        flowDirectionY,
        flowSpeed,
        breathAmplitude,
        breathHz,
        particleJitter,
        guidanceText,
        guidanceVisible,
        breathPattern,
        hapticGain,
      );
}
