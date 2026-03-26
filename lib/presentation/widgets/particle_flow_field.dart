import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/flight_session_controller.dart';
import '../../services/haptics/haptic_scheduler.dart';
import '../../services/haptics/platform/haptic_platform.dart';
import '../painters/vestibular_flow_painter.dart';

class ParticleFlowField extends ConsumerStatefulWidget {
  const ParticleFlowField({super.key});

  @override
  ConsumerState<ParticleFlowField> createState() => _ParticleFlowFieldState();
}

class _ParticleFlowFieldState extends ConsumerState<ParticleFlowField>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _flowTimeSec = 0;
  late final HapticScheduler _haptics;

  @override
  void initState() {
    super.initState();
    _haptics = HapticScheduler(MethodChannelHapticPlatform());
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    if (dt <= 0) return;
    _flowTimeSec += dt;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    _haptics.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      flightSessionProvider.select((s) => s.hapticSessionActive),
      (prev, active) {
        if (active) {
          final mul = ref.read(sessionSettingsProvider).hapticIntensity;
          _haptics.start(ref, intensityMul: mul);
        } else {
          _haptics.stop();
        }
      },
    );

    ref.listen(sessionSettingsProvider, (_, next) {
      if (ref.read(flightSessionProvider).hapticSessionActive) {
        _haptics.updateIntensity(next.hapticIntensity);
      }
    });

    final session = ref.watch(flightSessionProvider);

    return RepaintBoundary(
      child: CustomPaint(
        painter: VestibularFlowPainter(
          time: _flowTimeSec,
          tuning: session.tuning,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
