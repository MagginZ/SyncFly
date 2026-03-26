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
    required this.takeoffSequenceRunning,
    required this.hapticSessionActive,
    required this.descentRunning,
  });

  final FlightPhase phase;
  final double blendT;
  final FlightVisualTuning tuning;

  /// 起飞链：滑行→加速→拉起 自动进行中。
  final bool takeoffSequenceRunning;

  /// 触觉会话：起飞/下降阶段由用户操作开启，「进入平飞」或「已平稳」关闭。
  final bool hapticSessionActive;

  /// 下降引导是否进行中（可由「已平稳」结束）。
  final bool descentRunning;

  FlightSessionState copyWith({
    FlightPhase? phase,
    double? blendT,
    FlightVisualTuning? tuning,
    bool? takeoffSequenceRunning,
    bool? hapticSessionActive,
    bool? descentRunning,
  }) {
    return FlightSessionState(
      phase: phase ?? this.phase,
      blendT: blendT ?? this.blendT,
      tuning: tuning ?? this.tuning,
      takeoffSequenceRunning: takeoffSequenceRunning ?? this.takeoffSequenceRunning,
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
            takeoffSequenceRunning: false,
            hapticSessionActive: false,
            descentRunning: false,
          ),
        );

  final Ref _ref;
  Timer? _blendTimer;
  int _takeoffGen = 0;

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

  /// 滑块等变更 [SessionSettings] 后调用，使流速/呼吸等即时反映到当前阶段。
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

  /// 仅关闭触觉，不改变阶段（起飞中途紧急用）。
  void confirmStopHapticsOnly() {
    state = state.copyWith(hapticSessionActive: false);
  }

  /// 在 awaitingCruise：关闭触觉并进入平飞。
  Future<void> confirmEnterCruise() async {
    final ok = state.phase.maybeMap(
      awaitingCruise: (_) => true,
      orElse: () => false,
    );
    if (ok != true) return;
    state = state.copyWith(hapticSessionActive: false);
    await setPhase(const FlightPhase.cruising());
  }

  /// 在 descent：关闭触觉并回到准备。
  Future<void> confirmStableAfterDescent() async {
    final ok = state.phase.maybeMap(
      descent: (_) => true,
      orElse: () => false,
    );
    if (ok != true) return;
    state = state.copyWith(hapticSessionActive: false, descentRunning: false);
    await setPhase(const FlightPhase.idle());
  }

  /// 起飞：滑行 → 加速 → 拉起 → **待确认平飞**（不自动进入平飞文案）。
  Future<void> runTakeoffSequence() async {
    final gen = ++_takeoffGen;
    final settings = _ref.read(sessionSettingsProvider);
    final segment =
        (settings.takeoffSequenceSeconds / 3).ceil().clamp(3, 120);

    state = state.copyWith(
      takeoffSequenceRunning: true,
      hapticSessionActive: true,
    );

    Future<void> abortIfStale() async {
      if (gen != _takeoffGen) throw _SequenceCancelled();
    }

    try {
      await setPhase(const FlightPhase.taxiing());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: segment));
      await abortIfStale();

      await setPhase(const FlightPhase.takeoffAcceleration());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: segment));
      await abortIfStale();

      await setPhase(const FlightPhase.liftoffClimb());
      await abortIfStale();
      await Future<void>.delayed(Duration(seconds: segment));
      await abortIfStale();

      await setPhase(const FlightPhase.awaitingCruise());
    } on _SequenceCancelled {
      /* 被更新序列或中止 */
    } finally {
      if (gen == _takeoffGen) {
        state = state.copyWith(takeoffSequenceRunning: false);
      }
    }
  }

  /// 从平飞进入下降引导（触觉再开）。
  Future<void> startDescent() async {
    final ok = state.phase.maybeMap(
      cruising: (_) => true,
      orElse: () => false,
    );
    if (ok != true) return;
    state = state.copyWith(
      descentRunning: true,
      hapticSessionActive: true,
    );
    await setPhase(const FlightPhase.descent());
  }

  /// 中止起飞链或下降，回准备。
  Future<void> abortToIdle() async {
    _takeoffGen++;
    cancelBlend();
    state = state.copyWith(
      takeoffSequenceRunning: false,
      hapticSessionActive: false,
      descentRunning: false,
    );
    await setPhase(const FlightPhase.idle());
  }
}

class _SequenceCancelled implements Exception {}
