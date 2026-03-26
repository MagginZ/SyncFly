import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/breath/breath_envelope.dart';
import '../../domain/flight/breath_pattern_kind.dart';
import '../../domain/flight/flight_visual_tuning.dart';

/// 与 HTML 演示一致的中心径向粒子（状态由外层每帧更新）。
class MonolithParticle {
  MonolithParticle({
    required this.angle,
    required this.distance,
    required this.speed,
    required this.radius,
    required this.opacity,
    required this.isStreak,
    required this.colorMint,
    required this.x,
    required this.y,
  });

  double angle;
  double distance;
  double speed;
  double radius;
  final double opacity;
  final bool isStreak;
  final bool colorMint;
  double x;
  double y;
}

/// KINETIC_MONOLITH 风格：深色底、淡网格、径向光晕、中心粒子与起飞拖尾。
class KineticMonolithPainter extends CustomPainter {
  KineticMonolithPainter({
    required this.particles,
    required this.timeSec,
    required this.tuning,
  });

  final List<MonolithParticle> particles;
  final double timeSec;
  final FlightVisualTuning tuning;

  static const Color _primary = Color(0xFF9FFF88);
  static const Color _secondary = Color(0xFF8FF9A4);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0E0E0E);
    canvas.drawRect(Offset.zero & size, bg);

    _drawGrid(canvas, size);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final breathScale = breathRadialScaleMonolith(timeSec, tuning);
    final glowOpacity = breathAmbientOpacityMonolith(timeSec, tuning);
    final glowR = math.min(size.width, size.height) * 0.5;

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _primary.withValues(alpha: 0.28 * glowOpacity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.72],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: glowR));

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(breathScale);
    canvas.translate(-cx, -cy);
    canvas.drawCircle(Offset(cx, cy), glowR * 0.95, glowPaint);
    canvas.restore();

    final exhaleDim = tuning.breathPattern == BreathPatternKind.fourSevenEight &&
            breathIsExhale478(timeSec)
        ? 0.6
        : 1.0;

    var fx = tuning.flowDirectionX;
    var fy = tuning.flowDirectionY;
    final dirLen = math.sqrt(fx * fx + fy * fy);
    if (dirLen > 1e-6) {
      fx /= dirLen;
      fy /= dirLen;
    } else {
      fx = 0;
      fy = 0;
    }
    final flowMag = tuning.flowSpeed.clamp(0.0, 1.5);

    for (final p in particles) {
      final color = p.colorMint ? _primary : _secondary;
      final alpha = (p.opacity * exhaleDim).clamp(0.0, 1.0);

      /// 流动线条与粒子运动方向相反（尾迹拖在「来向」一侧）。
      if (flowMag > 0.32 && p.isStreak) {
        final streakPaint = Paint()
          ..color = color.withValues(alpha: alpha)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;
        final len = 14 * flowMag;
        canvas.drawLine(
          Offset(p.x, p.y),
          Offset(p.x - fx * len, p.y - fy * len),
          streakPaint,
        );
      }

      final rScale = 1.0 + 0.22 * flowMag;
      final solid = Paint()..color = color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(p.x, p.y), p.radius * rScale, solid);

      if (p.radius > 1.2) {
        final hi = Paint()..color = Colors.white.withValues(alpha: alpha * 0.85);
        canvas.drawCircle(Offset(p.x, p.y), p.radius * rScale * 0.3, hi);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    const step = 40.0;
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant KineticMonolithPainter oldDelegate) {
    return oldDelegate.timeSec != timeSec || oldDelegate.tuning != tuning;
  }
}
