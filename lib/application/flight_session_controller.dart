import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/lerp_utils.dart';
import '../domain/flight/flight_phase.dart';
import '../domain/flight/flight_phase_mapper.dart';
import '../domain/flight/flight_visual_tuning.dart';
import '../domain/settings/session_settings.dart';

final sessionSettingsProvider = StateProvider<SessionSettings>((ref) {
  return const SessionSettings();
});

final flightSessionProvider =
    StateNotifierProvider<FlightSessionNotifier, FlightSessionState>(
  FlightSessionNotifier.new,
);

class FlightSessionState {
  const FlightSessionState({
    required this.phase,
    required this.blendT,
    required this.tuning,
    required this.demoRunning,
  });

  final FlightPhase phase;
  final double blendT;
  final FlightVisualTuning tuning;
  final bool demoRunning;

  FlightSessionState copyWith({
    FlightPhase? phase,
    double? blendT,
    FlightVisualTuning? tuning,
    bool? demoRunning,
  }) {
    return FlightSessionState(
      phase: phase ?? this.phase,
      blendT: blendT ?? this.blendT,
      tuning: tuning ?? this.tuning,
      demoRunning: demoRunning ?? this.demoRunning,
    );
  }
}

class FlightSessionNotifier extends StateNotifier<FlightSessionState> {
  FlightSessionNotifier(this._ref)
      : super(
          FlightSessionState(
            phase: const FlightPhase.idle(),
            blendT: 1,
            tuning: tuningForPhase(
              const FlightPhase.idle(),
              const SessionSettings(),
            ),
            demoRunning: false,
          ),
        );

  final Ref _ref;
  Timer? _blendTimer;
  int _demoGen = 0;

  void cancelBlend() {
    _blendTimer?.cancel();
    _blendTimer = null;
  }

  @override
  void dispose() {
    cancelBlend();
    super.dispose();
  }

  Future<void> _blendTo(FlightVisualTuning target, SessionSettings settings) {
    final completer = Completer<void>();
    final from = state.tuning;
    final totalMs = settings.phaseBlendDuration.inMilliseconds;
    final started = DateTime.now();
    cancelBlend();
    _blendTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final elapsed = DateTime.now().difference(started).inMilliseconds;
      final rawT = totalMs <= 0 ? 1.0 : elapsed / totalMs;
      final t = rawT.clamp(0.0, 1.0);
      final curved = applyCurve(t, Curves.easeInOutCubic);
      final tuning = from.lerp(target, curved);
      state = state.copyWith(blendT: t, tuning: tuning);
      if (t >= 1.0) {
        cancelBlend();
        state = state.copyWith(blendT: 1, tuning: target);
        if (!completer.isCompleted) completer.complete();
      }
    });
    return completer.future;
  }

  Future<void> setPhase(FlightPhase next) async {
    final settings = _ref.read(sessionSettingsProvider);
    final target = tuningForPhase(next, settings);
    state = state.copyWith(phase: next, blendT: 0);
    await _blendTo(target, settings);
  }

  Future<void> runTakeoffDemo() async {
    final gen = ++_demoGen;
    final settings = _ref.read(sessionSettingsProvider);
    final third = (settings.takeoffSequenceSeconds / 3).ceil().clamp(3, 120);

    state = state.copyWith(demoRunning: true);

    Future<void> abortIfStale() async {
      if (gen != _demoGen) throw _DemoCancelled();
    }

    try {
      await setPhase(const FlightPhase.taxiing());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: third));
      await abortIfStale();

      await setPhase(const FlightPhase.takeoffAcceleration());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: third));
      await abortIfStale();

      await setPhase(const FlightPhase.liftoffClimb());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: third));
      await abortIfStale();

      await setPhase(const FlightPhase.levelOff());
      await abortIfStale();
      await Future<void>.delayed(
        Duration(seconds: settings.levelOffHoldSeconds.clamp(2, 600)),
      );
      await abortIfStale();

      await setPhase(const FlightPhase.idle());
    } on _DemoCancelled {
      /* replaced by newer demo */
    } finally {
      if (gen == _demoGen) {
        state = state.copyWith(demoRunning: false);
      }
    }
  }

  void stopDemo() {
    _demoGen++;
    state = state.copyWith(demoRunning: false);
  }

  /// 降落阶段示例：视觉上改为「向上」流动以利前庭耦合（可自行接入真实阶段切换）。
  Future<void> previewLandingFlow() async {
    final settings = _ref.read(sessionSettingsProvider);
    final rate = settings.animationRate;
    final upward = FlightVisualTuning(
      flowDirectionX: -0.06,
      flowDirectionY: -0.7 * rate,
      flowSpeed: 0.6 * rate,
      breathAmplitude: 0.1,
      breathHz: 0.16 * rate,
      particleJitter: 0.04,
      guidanceText: '进近拉平：视线跟随向上缓慢漂移的粒子',
      guidanceVisible: true,
    );
    state = state.copyWith(blendT: 0);
    await _blendTo(upward, settings);
  }
}

class _DemoCancelled implements Exception {}
