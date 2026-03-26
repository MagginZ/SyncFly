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
    required this.hapticSessionActive,
    required this.descentRunning,
  });

  final FlightPhase phase;
  final double blendT;
  final FlightVisualTuning tuning;

  /// 触觉会话：起飞链与下降阶段由用户点按钮开启；进入平飞或下降结束会关闭。
  final bool hapticSessionActive;

  /// 下降引导是否进行中（可由「已平稳」结束）。
  final bool descentRunning;

  FlightSessionState copyWith({
    FlightPhase? phase,
    double? blendT,
    FlightVisualTuning? tuning,
    bool? hapticSessionActive,
    bool? descentRunning,
  }) {
    return FlightSessionState(
      phase: phase ?? this.phase,
      blendT: blendT ?? this.blendT,
      tuning: tuning ?? this.tuning,
      hapticSessionActive: hapticSessionActive ?? this.hapticSessionActive,
      descentRunning: descentRunning ?? this.descentRunning,
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
            hapticSessionActive: false,
            descentRunning: false,
          ),
        );

  final Ref _ref;
  Timer? _blendTimer;

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

  void refreshTuningFromSettings() {
    if (_blendTimer != null) return;
    final settings = _ref.read(sessionSettingsProvider);
    final next = tuningForPhase(state.phase, settings);
    state = state.copyWith(tuning: next, blendT: 1);
  }

  Future<void> setPhase(FlightPhase next) async {
    final settings = _ref.read(sessionSettingsProvider);
    final target = tuningForPhase(next, settings);
    state = state.copyWith(phase: next, blendT: 0);
    await _blendTo(target, settings);
    refreshTuningFromSettings();
  }

  /// 仅关闭触觉，不改变阶段。
  void confirmStopHapticsOnly() {
    state = state.copyWith(hapticSessionActive: false);
  }

  /// 准备 → 滑行（开启触觉）。
  Future<void> startTakeoffToTaxiing() async {
    if (!state.phase.maybeMap(idle: (_) => true, orElse: () => false)) return;
    state = state.copyWith(hapticSessionActive: true);
    await setPhase(const FlightPhase.taxiing());
  }

  /// 滑行 → 加速推背。
  Future<void> confirmAcceleration() async {
    if (!state.phase.maybeMap(taxiing: (_) => true, orElse: () => false)) return;
    await setPhase(const FlightPhase.takeoffAcceleration());
  }

  /// 加速推背 → 拉起爬升。
  Future<void> confirmLiftoffClimbPhase() async {
    if (!state.phase.maybeMap(
      takeoffAcceleration: (_) => true,
      orElse: () => false,
    )) {
      return;
    }
    await setPhase(const FlightPhase.liftoffClimb());
  }

  /// 拉起爬升 → 平飞（关闭触觉）。
  Future<void> confirmEnterCruise() async {
    if (!state.phase.maybeMap(
      liftoffClimb: (_) => true,
      orElse: () => false,
    )) {
      return;
    }
    state = state.copyWith(hapticSessionActive: false);
    await setPhase(const FlightPhase.cruising());
  }

  /// 平飞 → 下降（再开触觉）。
  Future<void> startDescent() async {
    if (!state.phase.maybeMap(cruising: (_) => true, orElse: () => false)) return;
    state = state.copyWith(
      descentRunning: true,
      hapticSessionActive: true,
    );
    await setPhase(const FlightPhase.descent());
  }

  /// 下降结束 → 准备。
  Future<void> confirmStableAfterDescent() async {
    if (!state.phase.maybeMap(descent: (_) => true, orElse: () => false)) return;
    state = state.copyWith(hapticSessionActive: false, descentRunning: false);
    await setPhase(const FlightPhase.idle());
  }

  /// 任意阶段回准备。
  Future<void> abortToIdle() async {
    cancelBlend();
    state = state.copyWith(
      hapticSessionActive: false,
      descentRunning: false,
    );
    await setPhase(const FlightPhase.idle());
  }
}
