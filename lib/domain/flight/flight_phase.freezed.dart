// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flight_phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FlightPhase {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightPhaseCopyWith<$Res> {
  factory $FlightPhaseCopyWith(
    FlightPhase value,
    $Res Function(FlightPhase) then,
  ) = _$FlightPhaseCopyWithImpl<$Res, FlightPhase>;
}

/// @nodoc
class _$FlightPhaseCopyWithImpl<$Res, $Val extends FlightPhase>
    implements $FlightPhaseCopyWith<$Res> {
  _$FlightPhaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
    _$IdleImpl value,
    $Res Function(_$IdleImpl) then,
  ) = __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
    : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'FlightPhase.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements FlightPhase {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$TaxiingImplCopyWith<$Res> {
  factory _$$TaxiingImplCopyWith(
    _$TaxiingImpl value,
    $Res Function(_$TaxiingImpl) then,
  ) = __$$TaxiingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TaxiingImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$TaxiingImpl>
    implements _$$TaxiingImplCopyWith<$Res> {
  __$$TaxiingImplCopyWithImpl(
    _$TaxiingImpl _value,
    $Res Function(_$TaxiingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TaxiingImpl implements _Taxiing {
  const _$TaxiingImpl();

  @override
  String toString() {
    return 'FlightPhase.taxiing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TaxiingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return taxiing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return taxiing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (taxiing != null) {
      return taxiing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return taxiing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return taxiing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (taxiing != null) {
      return taxiing(this);
    }
    return orElse();
  }
}

abstract class _Taxiing implements FlightPhase {
  const factory _Taxiing() = _$TaxiingImpl;
}

/// @nodoc
abstract class _$$TakeoffAccelerationImplCopyWith<$Res> {
  factory _$$TakeoffAccelerationImplCopyWith(
    _$TakeoffAccelerationImpl value,
    $Res Function(_$TakeoffAccelerationImpl) then,
  ) = __$$TakeoffAccelerationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TakeoffAccelerationImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$TakeoffAccelerationImpl>
    implements _$$TakeoffAccelerationImplCopyWith<$Res> {
  __$$TakeoffAccelerationImplCopyWithImpl(
    _$TakeoffAccelerationImpl _value,
    $Res Function(_$TakeoffAccelerationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TakeoffAccelerationImpl implements _TakeoffAcceleration {
  const _$TakeoffAccelerationImpl();

  @override
  String toString() {
    return 'FlightPhase.takeoffAcceleration()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TakeoffAccelerationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return takeoffAcceleration();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return takeoffAcceleration?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (takeoffAcceleration != null) {
      return takeoffAcceleration();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return takeoffAcceleration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return takeoffAcceleration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (takeoffAcceleration != null) {
      return takeoffAcceleration(this);
    }
    return orElse();
  }
}

abstract class _TakeoffAcceleration implements FlightPhase {
  const factory _TakeoffAcceleration() = _$TakeoffAccelerationImpl;
}

/// @nodoc
abstract class _$$LiftoffClimbImplCopyWith<$Res> {
  factory _$$LiftoffClimbImplCopyWith(
    _$LiftoffClimbImpl value,
    $Res Function(_$LiftoffClimbImpl) then,
  ) = __$$LiftoffClimbImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LiftoffClimbImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$LiftoffClimbImpl>
    implements _$$LiftoffClimbImplCopyWith<$Res> {
  __$$LiftoffClimbImplCopyWithImpl(
    _$LiftoffClimbImpl _value,
    $Res Function(_$LiftoffClimbImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LiftoffClimbImpl implements _LiftoffClimb {
  const _$LiftoffClimbImpl();

  @override
  String toString() {
    return 'FlightPhase.liftoffClimb()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LiftoffClimbImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return liftoffClimb();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return liftoffClimb?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (liftoffClimb != null) {
      return liftoffClimb();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return liftoffClimb(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return liftoffClimb?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (liftoffClimb != null) {
      return liftoffClimb(this);
    }
    return orElse();
  }
}

abstract class _LiftoffClimb implements FlightPhase {
  const factory _LiftoffClimb() = _$LiftoffClimbImpl;
}

/// @nodoc
abstract class _$$CruisingImplCopyWith<$Res> {
  factory _$$CruisingImplCopyWith(
    _$CruisingImpl value,
    $Res Function(_$CruisingImpl) then,
  ) = __$$CruisingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CruisingImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$CruisingImpl>
    implements _$$CruisingImplCopyWith<$Res> {
  __$$CruisingImplCopyWithImpl(
    _$CruisingImpl _value,
    $Res Function(_$CruisingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CruisingImpl implements _Cruising {
  const _$CruisingImpl();

  @override
  String toString() {
    return 'FlightPhase.cruising()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CruisingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return cruising();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return cruising?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (cruising != null) {
      return cruising();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return cruising(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return cruising?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (cruising != null) {
      return cruising(this);
    }
    return orElse();
  }
}

abstract class _Cruising implements FlightPhase {
  const factory _Cruising() = _$CruisingImpl;
}

/// @nodoc
abstract class _$$DescentImplCopyWith<$Res> {
  factory _$$DescentImplCopyWith(
    _$DescentImpl value,
    $Res Function(_$DescentImpl) then,
  ) = __$$DescentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DescentImplCopyWithImpl<$Res>
    extends _$FlightPhaseCopyWithImpl<$Res, _$DescentImpl>
    implements _$$DescentImplCopyWith<$Res> {
  __$$DescentImplCopyWithImpl(
    _$DescentImpl _value,
    $Res Function(_$DescentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DescentImpl implements _Descent {
  const _$DescentImpl();

  @override
  String toString() {
    return 'FlightPhase.descent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DescentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() taxiing,
    required TResult Function() takeoffAcceleration,
    required TResult Function() liftoffClimb,
    required TResult Function() cruising,
    required TResult Function() descent,
  }) {
    return descent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? taxiing,
    TResult? Function()? takeoffAcceleration,
    TResult? Function()? liftoffClimb,
    TResult? Function()? cruising,
    TResult? Function()? descent,
  }) {
    return descent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? taxiing,
    TResult Function()? takeoffAcceleration,
    TResult Function()? liftoffClimb,
    TResult Function()? cruising,
    TResult Function()? descent,
    required TResult orElse(),
  }) {
    if (descent != null) {
      return descent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_Taxiing value) taxiing,
    required TResult Function(_TakeoffAcceleration value) takeoffAcceleration,
    required TResult Function(_LiftoffClimb value) liftoffClimb,
    required TResult Function(_Cruising value) cruising,
    required TResult Function(_Descent value) descent,
  }) {
    return descent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_Taxiing value)? taxiing,
    TResult? Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult? Function(_LiftoffClimb value)? liftoffClimb,
    TResult? Function(_Cruising value)? cruising,
    TResult? Function(_Descent value)? descent,
  }) {
    return descent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_Taxiing value)? taxiing,
    TResult Function(_TakeoffAcceleration value)? takeoffAcceleration,
    TResult Function(_LiftoffClimb value)? liftoffClimb,
    TResult Function(_Cruising value)? cruising,
    TResult Function(_Descent value)? descent,
    required TResult orElse(),
  }) {
    if (descent != null) {
      return descent(this);
    }
    return orElse();
  }
}

abstract class _Descent implements FlightPhase {
  const factory _Descent() = _$DescentImpl;
}
