import 'package:flutter/material.dart';
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
  late final AnimationController _controller;
  late final HapticScheduler _haptics;
  var _hapticStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..repeat();
    _haptics = HapticScheduler(MethodChannelHapticPlatform());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hapticStarted) return;
    _hapticStarted = true;
    final mul = ref.read(sessionSettingsProvider).hapticIntensity;
    _haptics.start(ref, intensityMul: mul);
  }

  @override
  void dispose() {
    _haptics.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionSettingsProvider, (_, next) {
      _haptics.updateIntensity(next.hapticIntensity);
    });

    final session = ref.watch(flightSessionProvider);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: VestibularFlowPainter(
              time: _controller.value * 400,
              tuning: session.tuning,
            ),
            child: child,
          ),
        );
      },
      child: const SizedBox.expand(),
    );
  }
}
