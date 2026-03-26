import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/breath/breath_envelope.dart';
import '../../domain/flight/flight_visual_tuning.dart';

class VestibularFlowPainter extends CustomPainter {
  VestibularFlowPainter({
    required this.time,
    required this.tuning,
  });

  final double time;
  final FlightVisualTuning tuning;

  static const int _particleCount = 56;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = breathParticleScale(time, tuning);
    final opacityBreath = breathOpacityFactor(time, tuning);

    final rnd = math.Random(42);
    final basePaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < _particleCount; i++) {
      final u = rnd.nextDouble();
      final v = rnd.nextDouble();
      var x = u * size.width;
      var y = v * size.height;

      final wobble = tuning.particleJitter * math.sin(time * 2.2 + i);
      x += wobble * 6;
      y += wobble * 4;

      final driftX = tuning.flowDirectionX * tuning.flowSpeed * time * 42;
      final driftY = tuning.flowDirectionY * tuning.flowSpeed * time * 42;
      x = _wrap(x + driftX, size.width);
      y = _wrap(y + driftY, size.height);

      final opacity = (0.14 + 0.22 * (i / _particleCount)) * opacityBreath;
      basePaint.color =
          Colors.white.withValues(alpha: opacity.clamp(0.04, 0.88));
      final r = (1.1 + (i % 5)) * scale;
      canvas.drawCircle(Offset(x, y), r, basePaint);
    }
  }

  double _wrap(double v, double max) {
    if (max <= 0) return v;
    var x = v % max;
    if (x < 0) x += max;
    return x;
  }

  @override
  bool shouldRepaint(covariant VestibularFlowPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.tuning != tuning;
  }
}
