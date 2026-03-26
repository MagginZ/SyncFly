import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/flight_session_controller.dart';
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

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(flightSessionProvider);
    final settings = ref.watch(sessionSettingsProvider);

    ref.listen(sessionSettingsProvider, (_, next) {
      _audio.setVolume(next.masterVolume);
      ref.read(flightSessionProvider.notifier).refreshTuningFromSettings();
    });

    ref.listen(flightSessionProvider.select((s) => s.hapticSessionActive),
        (prev, active) async {
      if (active) {
        final vol = ref.read(sessionSettingsProvider).masterVolume;
        await _audio.setVolume(vol);
        if (_audio.isPrepared && mounted) await _audio.resume();
      } else if (mounted) {
        await _audio.pause();
      }
    });

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
                            onPressed: session.demoRunning
                                ? null
                                : () => ref
                                    .read(flightSessionProvider.notifier)
                                    .runTakeoffDemo(),
                            child: Text(session.demoRunning ? '起降进行中…' : '开始起飞'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          tooltip: '预览降落向上补偿流场',
                          onPressed: session.demoRunning
                              ? null
                              : () => ref
                                  .read(flightSessionProvider.notifier)
                                  .previewLandingFlow(),
                          icon: const Icon(Icons.flight_land_rounded),
                        ),
                      ],
                    ),
                    if (session.demoRunning)
                      TextButton(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .stopDemo(),
                        child: const Text('停止起降流程'),
                      ),
                    if (session.hapticSessionActive)
                      FilledButton.tonal(
                        onPressed: () => ref
                            .read(flightSessionProvider.notifier)
                            .confirmStopHaptics(),
                        child: const Text('已平稳，关闭触觉'),
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
