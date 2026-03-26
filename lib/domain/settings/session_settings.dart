import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_settings.freezed.dart';

@freezed
class SessionSettings with _$SessionSettings {
  const factory SessionSettings({
    @Default(12) int takeoffSequenceSeconds,
    @Default(10) int levelOffHoldSeconds,
    @Default(1.0) double animationRate,
    @Default(1.0) double hapticIntensity,
    @Default(0.65) double masterVolume,
    @Default(Duration(milliseconds: 900)) Duration phaseBlendDuration,
  }) = _SessionSettings;
}
