import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight_phase.freezed.dart';

/// 飞行体感状态机：准备 → 滑行 → 加速 → 拉起 → 待确认平飞 → 平飞 → 下降 → 回准备。
@freezed
class FlightPhase with _$FlightPhase {
  const factory FlightPhase.idle() = _Idle;
  const factory FlightPhase.taxiing() = _Taxiing;
  const factory FlightPhase.takeoffAcceleration() = _TakeoffAcceleration;
  const factory FlightPhase.liftoffClimb() = _LiftoffClimb;

  /// 爬升结束：等待用户确认后再进入平飞文案与流场。
  const factory FlightPhase.awaitingCruise() = _AwaitingCruise;

  /// 平飞巡航（用户确认后）。
  const factory FlightPhase.cruising() = _Cruising;

  /// 进近下降：视觉以上飘为主，模拟失重/拉平补偿。
  const factory FlightPhase.descent() = _Descent;
}
