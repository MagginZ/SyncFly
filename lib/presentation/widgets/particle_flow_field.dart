import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/flight_session_controller.dart';
import '../../core/breath/breath_envelope.dart';
import '../../domain/flight/breath_pattern_kind.dart';
import '../../services/haptics/vibration_flight_haptics.dart';
import '../painters/kinetic_monolith_painter.dart';
import 'particle_phase_kinematics.dart';

/// 全屏「Kinetic Monolith」式粒子场：中心径向、4-7-8 呼吸扩张、阶段驱动的垂直漂移与起飞拖尾。
class ParticleFlowField extends ConsumerStatefulWidget {
  const ParticleFlowField({super.key});

  @override
  ConsumerState<ParticleFlowField> createState() => _ParticleFlowFieldState();
}

class _ParticleFlowFieldState extends ConsumerState<ParticleFlowField>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _flowTimeSec = 0;
  Duration? _lastElapsed;

  final List<MonolithParticle> _particles = [];
  Size? _canvasSize;
  double _smoothedDx = 0;
  double _smoothedDy = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  Future<void> _onFlightSessionVibration(
    FlightSessionState? prev,
    FlightSessionState next,
  ) async {
    if (kIsWeb) return;
    if (!next.hapticSessionActive) {
      await VibrationFlightHaptics.stop();
      return;
    }
    final mul = ref.read(sessionSettingsProvider).hapticIntensity;
    if (mul < 0.05) {
      await VibrationFlightHaptics.stop();
      return;
    }
    final prevPhase = prev?.phase;
    final nextPhase = next.phase;
    if (prevPhase != null && prevPhase != nextPhase) {
      if (VibrationFlightHaptics.isTakeoffToLiftoff(prevPhase, nextPhase)) {
        await VibrationFlightHaptics.playRotationPulse(mul);
        await Future<void>.delayed(const Duration(milliseconds: 80));
      }
      if (VibrationFlightHaptics.isDescentToIdle(prevPhase, nextPhase)) {
        await VibrationFlightHaptics.playTouchdownPulse(mul);
        await Future<void>.delayed(const Duration(milliseconds: 80));
      }
    }
    await VibrationFlightHaptics.applySustainedPhasePattern(nextPhase, mul);
  }

  void _onTick(Duration elapsed) {
    final dt = _lastElapsed == null
        ? 0.016
        : (elapsed - _lastElapsed!).inMicroseconds /
            Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;
    if (dt <= 0 || dt > 0.5) return;

    _flowTimeSec += dt;

    final rb = context.findRenderObject() as RenderBox?;
    if (rb != null && rb.hasSize) {
      _stepPhysics(rb.size, dt);
    }
    if (mounted) setState(() {});
  }

  void _initParticles(Size size) {
    final rnd = math.Random(42);
    final n = (size.shortestSide * 1.8).round().clamp(400, 1600);
    final maxR = math.min(size.width, size.height) * 0.42;
    final cx = size.width / 2;
    final cy = size.height / 2;
    _particles
      ..clear()
      ..addAll(
        List.generate(n, (_) {
          final angle = rnd.nextDouble() * math.pi * 2;
          final distance = math.pow(rnd.nextDouble(), 0.6).toDouble() * maxR;
          final x = cx + math.cos(angle) * distance;
          final y = cy + math.sin(angle) * distance;
          return MonolithParticle(
            angle: angle,
            distance: distance,
            speed: 0.001 + rnd.nextDouble() * 0.003,
            radius: 0.4 + rnd.nextDouble() * 1.5,
            opacity: 0.2 + rnd.nextDouble() * 0.7,
            isStreak: rnd.nextDouble() < 0.05,
            colorMint: rnd.nextDouble() > 0.7,
            x: x,
            y: y,
          );
        }),
      );
  }

  void _stepPhysics(Size size, double dt) {
    final session = ref.read(flightSessionProvider);
    final settings = ref.read(sessionSettingsProvider);
    final tuning = session.tuning;
    final rate = settings.animationRate.clamp(0.3, 1.5);

    if (_particles.isEmpty || _canvasSize != size) {
      _canvasSize = size;
      _initParticles(size);
    }

    final kin = particleKinematicsForPhase(session.phase);
    var fx = kin.fx;
    var fy = kin.fy;
    final dirLen = math.sqrt(fx * fx + fy * fy);
    if (dirLen > 1e-6) {
      fx /= dirLen;
      fy /= dirLen;
    } else {
      fx = 0;
      fy = 0;
    }

    /// 漂移（像素）：阶段强度 × 用户动画速率（与滑块联动）。
    final driftScale = 52.0 * rate * kin.driftStrength;
    final targetDx = fx * driftScale;
    final targetDy = fy * driftScale;
    final smoothK = 1 - math.exp(-dt * 9);
    _smoothedDx += (targetDx - _smoothedDx) * smoothK;
    _smoothedDy += (targetDy - _smoothedDy) * smoothK;

    final hold = tuning.breathPattern == BreathPatternKind.fourSevenEight &&
        breathIsHold478(_flowTimeSec);

    /// 轨道角速度：屏息时减半；阶段相对频率 × 动画速率 × breathHz 脉动。
    final breathOrbitPulse =
        1.0 + 0.22 * math.sin(2 * math.pi * tuning.breathHz * _flowTimeSec);
    final orbitMul = (hold ? 0.5 : 1.0) *
        rate *
        60.0 *
        dt *
        kin.orbitFrequencyMul *
        breathOrbitPulse.clamp(0.82, 1.18);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final breathScale = breathRadialScaleMonolith(_flowTimeSec, tuning);
    final follow = 1 - math.exp(-dt * 3.1);

    for (final p in _particles) {
      p.angle += p.speed * orbitMul;
      final expansion = breathScale * p.distance;
      final w = 2 + p.radius * 0.35;
      final targetX = cx + math.cos(p.angle) * expansion + _smoothedDx * w;
      final targetY = cy + math.sin(p.angle) * expansion + _smoothedDy * w;
      p.x += (targetX - p.x) * follow;
      p.y += (targetY - p.y) * follow;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    unawaited(VibrationFlightHaptics.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(flightSessionProvider, (prev, next) {
      unawaited(_onFlightSessionVibration(prev, next));
    });

    ref.listen(
      sessionSettingsProvider.select((s) => s.hapticIntensity),
      (prev, next) {
        if (!ref.read(flightSessionProvider).hapticSessionActive) return;
        if (kIsWeb) return;
        if (next < 0.05) {
          unawaited(VibrationFlightHaptics.stop());
          return;
        }
        final phase = ref.read(flightSessionProvider).phase;
        unawaited(
          VibrationFlightHaptics.applySustainedPhasePattern(phase, next),
        );
      },
    );

    final session = ref.watch(flightSessionProvider);
    ref.watch(sessionSettingsProvider.select((s) => s.animationRate));

    final mag = math.sqrt(
      _smoothedDx * _smoothedDx + _smoothedDy * _smoothedDy,
    );
    final strokeDirX = mag > 1e-6 ? _smoothedDx / mag : 0.0;
    final strokeDirY = mag > 1e-6 ? _smoothedDy / mag : 0.0;
    final flowMagPaint = (mag / 48.0).clamp(0.0, 1.5);

    return RepaintBoundary(
      child: CustomPaint(
        painter: KineticMonolithPainter(
          particles: _particles,
          timeSec: _flowTimeSec,
          tuning: session.tuning,
          strokeDirX: strokeDirX,
          strokeDirY: strokeDirY,
          flowMagPaint: flowMagPaint,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
