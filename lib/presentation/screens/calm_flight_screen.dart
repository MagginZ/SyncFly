import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/flight_session_controller.dart';
import '../../core/breath/breath_envelope.dart';
import '../../services/audio/ambient_audio_service.dart';
import '../widgets/body_guidance_banner.dart';
import '../widgets/particle_flow_field.dart';

class CalmFlightScreen extends ConsumerStatefulWidget {
  const CalmFlightScreen({super.key});

  @override
  ConsumerState<CalmFlightScreen> createState() => _CalmFlightScreenState();
}

class _CalmFlightScreenState extends ConsumerState<CalmFlightScreen> {
  late final AmbientAudioService _audio;
  var _audioPrimed = false;
  Timer? _audioBreathTimer;

  @override
  void initState() {
    super.initState();
    _audio = AmbientAudioService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_audioPrimed) return;
    _audioPrimed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audio.tryPrepareLoop('audio/white_noise.mp3');
      final vol = ref.read(sessionSettingsProvider).masterVolume;
      await _audio.setVolume(vol);
      if (_audio.isPrepared && mounted) await _audio.pause();
    });
  }

  void _startAudioBreathModulation() {
    _audioBreathTimer?.cancel();
    _audioBreathTimer = Timer.periodic(const Duration(milliseconds: 110), (_) {
      if (!mounted) return;
      final session = ref.read(flightSessionProvider);
      if (!session.hapticSessionActive) return;
      final settings = ref.read(sessionSettingsProvider);
      final t = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final e = breathEnvelope01(t, session.tuning);
      final vol = settings.masterVolume * (0.52 + 0.48 * e);
      _audio.setVolume(vol);
    });
  }

  void _stopAudioBreathModulation() {
    _audioBreathTimer?.cancel();
    _audioBreathTimer = null;
    final base = ref.read(sessionSettingsProvider).masterVolume;
    _audio.setVolume(base);
  }

  @override
  void dispose() {
    _audioBreathTimer?.cancel();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(flightSessionProvider);
    final settings = ref.watch(sessionSettingsProvider);

    ref.listen(sessionSettingsProvider, (_, next) {
      if (!ref.read(flightSessionProvider).hapticSessionActive) {
        _audio.setVolume(next.masterVolume);
      }
      ref.read(flightSessionProvider.notifier).refreshTuningFromSettings();
    });

    ref.listen(flightSessionProvider.select((s) => s.hapticSessionActive),
        (prev, active) async {
      if (active) {
        await _audio.setVolume(ref.read(sessionSettingsProvider).masterVolume);
        if (_audio.isPrepared && mounted) {
          await _audio.resume();
          _startAudioBreathModulation();
        }
      } else {
        _stopAudioBreathModulation();
        if (mounted) await _audio.pause();
      }
    });

    final midTakeoff = session.phase.maybeMap(
      taxiing: (_) => true,
      takeoffAcceleration: (_) => true,
      liftoffClimb: (_) => true,
      orElse: () => false,
    );

    final showEnterCruise = session.phase.maybeMap(
      awaitingCruise: (_) => true,
      orElse: () => false,
    );

    final showStartDescent = session.phase.maybeMap(
      cruising: (_) => true,
      orElse: () => false,
    );

    final showStableAfterDescent = session.phase.maybeMap(
      descent: (_) => true,
      orElse: () => false,
    );

    final atIdle = session.phase.maybeMap(
      idle: (_) => true,
      orElse: () => false,
    ) ==
        true;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ParticleFlowField(),
          Align(
            alignment: Alignment.topCenter,
            child: BodyGuidanceBanner(
              text: session.tuning.guidanceText,
              visible: session.tuning.guidanceVisible,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SliderTile(
                      label: '动画速率',
                      value: settings.animationRate,
                      onChanged: (v) => ref
                          .read(sessionSettingsProvider.notifier)
                          .update((s) => s.copyWith(animationRate: v)),
                    ),
                    _SliderTile(
                      label: '触觉强度',
                      value: settings.hapticIntensity,
                      onChanged: (v) => ref
                          .read(sessionSettingsProvider.notifier)
                          .update((s) => s.copyWith(hapticIntensity: v)),
                    ),
                    _SliderTile(
                      label: '环境音量（有音频文件时生效）',
                      value: settings.masterVolume,
                      onChanged: (v) => ref
                          .read(sessionSettingsProvider.notifier)
                          .update((s) => s.copyWith(masterVolume: v)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: session.takeoffSequenceRunning || !atIdle
                                ? null
                                : () => ref
                                    .read(flightSessionProvider.notifier)
                                    .runTakeoffSequence(),
                            child: Text(
                              session.takeoffSequenceRunning
                                  ? '起飞进行中…'
                                  : '开始起飞',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (session.takeoffSequenceRunning || session.descentRunning)
                      TextButton(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .abortToIdle(),
                        child: const Text('中止并回准备'),
                      ),
                    if (midTakeoff && session.hapticSessionActive)
                      TextButton(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .confirmStopHapticsOnly(),
                        child: const Text('仅关闭触觉'),
                      ),
                    if (showEnterCruise)
                      FilledButton.tonal(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .confirmEnterCruise(),
                        child: const Text('已平稳，进入平飞'),
                      ),
                    if (showStartDescent && !session.descentRunning)
                      FilledButton.tonal(
                        onPressed: session.takeoffSequenceRunning
                            ? null
                            : () => ref
                                .read(flightSessionProvider.notifier)
                                .startDescent(),
                        child: const Text('开始下降'),
                      ),
                    if (showStableAfterDescent)
                      FilledButton.tonal(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .confirmStableAfterDescent(),
                        child: const Text('已平稳'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label (${value.toStringAsFixed(2)})',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white70,
              ),
        ),
        Slider(value: value, min: 0, max: 1.5, onChanged: onChanged),
      ],
    );
  }
}
