import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight_phase.freezed.dart';

/// 飞行体感阶段（可自行增加进近、着陆等）。
@freezed
class FlightPhase with _$FlightPhase {
  const factory FlightPhase.idle() = _Idle;
  const factory FlightPhase.taxiing() = _Taxiing;
  const factory FlightPhase.takeoffAcceleration() = _TakeoffAcceleration;
  const factory FlightPhase.liftoffClimb() = _LiftoffClimb;
  const factory FlightPhase.levelOff() = _LevelOff;
}
