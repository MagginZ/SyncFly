import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight_phase.freezed.dart';

/// 飞行体感状态机：各阶段均由用户按钮切换（设备无法感知真实飞行状态）。
/// 准备 → 滑行 → 加速推背 → 拉起爬升 → 平飞 → 下降 → 回准备。
@freezed
class FlightPhase with _$FlightPhase {
  const factory FlightPhase.idle() = _Idle;
  const factory FlightPhase.taxiing() = _Taxiing;
  const factory FlightPhase.takeoffAcceleration() = _TakeoffAcceleration;
  const factory FlightPhase.liftoffClimb() = _LiftoffClimb;

  /// 平飞巡航（用户从「拉起爬升」确认进入）。
  const factory FlightPhase.cruising() = _Cruising;

  /// 进近下降：视觉以上飘为主，模拟失重/拉平补偿。
  const factory FlightPhase.descent() = _Descent;
}
