import '../../core/utils/lerp_utils.dart';

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
  });

  /// 屏幕坐标系：向右为正；轻微负值表示「向后」趋势。
  final double flowDirectionX;
  /// 向下为正；起飞补偿朝「后下」流时可取较大正值；降落改为负值（向上）。
  final double flowDirectionY;
  final double flowSpeed;
  final double breathAmplitude;
  final double breathHz;
  final double particleJitter;
  final String guidanceText;
  final bool guidanceVisible;

  FlightVisualTuning lerp(FlightVisualTuning b, double t) {
    final x = lerpDouble(flowDirectionX, b.flowDirectionX, t);
    final y = lerpDouble(flowDirectionY, b.flowDirectionY, t);
    final s = lerpDouble(flowSpeed, b.flowSpeed, t);
    final ba = lerpDouble(breathAmplitude, b.breathAmplitude, t);
    final bh = lerpDouble(breathHz, b.breathHz, t);
    final pj = lerpDouble(particleJitter, b.particleJitter, t);
    return FlightVisualTuning(
      flowDirectionX: x,
      flowDirectionY: y,
      flowSpeed: s,
      breathAmplitude: ba,
      breathHz: bh,
      particleJitter: pj,
      guidanceText: t < 0.5 ? guidanceText : b.guidanceText,
      guidanceVisible: t < 0.5 ? guidanceVisible : b.guidanceVisible,
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
          other.guidanceVisible == guidanceVisible;

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
      );
}
