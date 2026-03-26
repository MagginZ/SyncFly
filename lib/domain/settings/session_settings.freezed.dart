// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SessionSettings {
  int get takeoffSequenceSeconds => throw _privateConstructorUsedError;
  int get levelOffHoldSeconds => throw _privateConstructorUsedError;
  double get animationRate => throw _privateConstructorUsedError;
  double get hapticIntensity => throw _privateConstructorUsedError;
  double get masterVolume => throw _privateConstructorUsedError;
  Duration get phaseBlendDuration => throw _privateConstructorUsedError;

  /// Create a copy of SessionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSettingsCopyWith<SessionSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSettingsCopyWith<$Res> {
  factory $SessionSettingsCopyWith(
    SessionSettings value,
    $Res Function(SessionSettings) then,
  ) = _$SessionSettingsCopyWithImpl<$Res, SessionSettings>;
  @useResult
  $Res call({
    int takeoffSequenceSeconds,
    int levelOffHoldSeconds,
    double animationRate,
    double hapticIntensity,
    double masterVolume,
    Duration phaseBlendDuration,
  });
}

/// @nodoc
class _$SessionSettingsCopyWithImpl<$Res, $Val extends SessionSettings>
    implements $SessionSettingsCopyWith<$Res> {
  _$SessionSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? takeoffSequenceSeconds = null,
    Object? levelOffHoldSeconds = null,
    Object? animationRate = null,
    Object? hapticIntensity = null,
    Object? masterVolume = null,
    Object? phaseBlendDuration = null,
  }) {
    return _then(
      _value.copyWith(
            takeoffSequenceSeconds: null == takeoffSequenceSeconds
                ? _value.takeoffSequenceSeconds
                : takeoffSequenceSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            levelOffHoldSeconds: null == levelOffHoldSeconds
                ? _value.levelOffHoldSeconds
                : levelOffHoldSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            animationRate: null == animationRate
                ? _value.animationRate
                : animationRate // ignore: cast_nullable_to_non_nullable
                      as double,
            hapticIntensity: null == hapticIntensity
                ? _value.hapticIntensity
                : hapticIntensity // ignore: cast_nullable_to_non_nullable
                      as double,
            masterVolume: null == masterVolume
                ? _value.masterVolume
                : masterVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            phaseBlendDuration: null == phaseBlendDuration
                ? _value.phaseBlendDuration
                : phaseBlendDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionSettingsImplCopyWith<$Res>
    implements $SessionSettingsCopyWith<$Res> {
  factory _$$SessionSettingsImplCopyWith(
    _$SessionSettingsImpl value,
    $Res Function(_$SessionSettingsImpl) then,
  ) = __$$SessionSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int takeoffSequenceSeconds,
    int levelOffHoldSeconds,
    double animationRate,
    double hapticIntensity,
    double masterVolume,
    Duration phaseBlendDuration,
  });
}

/// @nodoc
class __$$SessionSettingsImplCopyWithImpl<$Res>
    extends _$SessionSettingsCopyWithImpl<$Res, _$SessionSettingsImpl>
    implements _$$SessionSettingsImplCopyWith<$Res> {
  __$$SessionSettingsImplCopyWithImpl(
    _$SessionSettingsImpl _value,
    $Res Function(_$SessionSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? takeoffSequenceSeconds = null,
    Object? levelOffHoldSeconds = null,
    Object? animationRate = null,
    Object? hapticIntensity = null,
    Object? masterVolume = null,
    Object? phaseBlendDuration = null,
  }) {
    return _then(
      _$SessionSettingsImpl(
        takeoffSequenceSeconds: null == takeoffSequenceSeconds
            ? _value.takeoffSequenceSeconds
            : takeoffSequenceSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        levelOffHoldSeconds: null == levelOffHoldSeconds
            ? _value.levelOffHoldSeconds
            : levelOffHoldSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        animationRate: null == animationRate
            ? _value.animationRate
            : animationRate // ignore: cast_nullable_to_non_nullable
                  as double,
        hapticIntensity: null == hapticIntensity
            ? _value.hapticIntensity
            : hapticIntensity // ignore: cast_nullable_to_non_nullable
                  as double,
        masterVolume: null == masterVolume
            ? _value.masterVolume
            : masterVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        phaseBlendDuration: null == phaseBlendDuration
            ? _value.phaseBlendDuration
            : phaseBlendDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc

class _$SessionSettingsImpl implements _SessionSettings {
  const _$SessionSettingsImpl({
    this.takeoffSequenceSeconds = 12,
    this.levelOffHoldSeconds = 10,
    this.animationRate = 1.0,
    this.hapticIntensity = 1.0,
    this.masterVolume = 0.65,
    this.phaseBlendDuration = const Duration(milliseconds: 900),
  });

  @override
  @JsonKey()
  final int takeoffSequenceSeconds;
  @override
  @JsonKey()
  final int levelOffHoldSeconds;
  @override
  @JsonKey()
  final double animationRate;
  @override
  @JsonKey()
  final double hapticIntensity;
  @override
  @JsonKey()
  final double masterVolume;
  @override
  @JsonKey()
  final Duration phaseBlendDuration;

  @override
  String toString() {
    return 'SessionSettings(takeoffSequenceSeconds: $takeoffSequenceSeconds, levelOffHoldSeconds: $levelOffHoldSeconds, animationRate: $animationRate, hapticIntensity: $hapticIntensity, masterVolume: $masterVolume, phaseBlendDuration: $phaseBlendDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSettingsImpl &&
            (identical(other.takeoffSequenceSeconds, takeoffSequenceSeconds) ||
                other.takeoffSequenceSeconds == takeoffSequenceSeconds) &&
            (identical(other.levelOffHoldSeconds, levelOffHoldSeconds) ||
                other.levelOffHoldSeconds == levelOffHoldSeconds) &&
            (identical(other.animationRate, animationRate) ||
                other.animationRate == animationRate) &&
            (identical(other.hapticIntensity, hapticIntensity) ||
                other.hapticIntensity == hapticIntensity) &&
            (identical(other.masterVolume, masterVolume) ||
                other.masterVolume == masterVolume) &&
            (identical(other.phaseBlendDuration, phaseBlendDuration) ||
                other.phaseBlendDuration == phaseBlendDuration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    takeoffSequenceSeconds,
    levelOffHoldSeconds,
    animationRate,
    hapticIntensity,
    masterVolume,
    phaseBlendDuration,
  );

  /// Create a copy of SessionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSettingsImplCopyWith<_$SessionSettingsImpl> get copyWith =>
      __$$SessionSettingsImplCopyWithImpl<_$SessionSettingsImpl>(
        this,
        _$identity,
      );
}

abstract class _SessionSettings implements SessionSettings {
  const factory _SessionSettings({
    final int takeoffSequenceSeconds,
    final int levelOffHoldSeconds,
    final double animationRate,
    final double hapticIntensity,
    final double masterVolume,
    final Duration phaseBlendDuration,
  }) = _$SessionSettingsImpl;

  @override
  int get takeoffSequenceSeconds;
  @override
  int get levelOffHoldSeconds;
  @override
  double get animationRate;
  @override
  double get hapticIntensity;
  @override
  double get masterVolume;
  @override
  Duration get phaseBlendDuration;

  /// Create a copy of SessionSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSettingsImplCopyWith<_$SessionSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
