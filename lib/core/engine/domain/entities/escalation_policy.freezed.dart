// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EscalationPolicy {
  int get maxSnoozes => throw _privateConstructorUsedError;
  int get snoozeBaseDelayMinutes => throw _privateConstructorUsedError;
  int get responseWindowSeconds => throw _privateConstructorUsedError;
  int get maxEscalations => throw _privateConstructorUsedError;
  int get escalationIntervalSeconds => throw _privateConstructorUsedError;
  int get confirmationWindowSeconds => throw _privateConstructorUsedError;

  /// Create a copy of EscalationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EscalationPolicyCopyWith<EscalationPolicy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscalationPolicyCopyWith<$Res> {
  factory $EscalationPolicyCopyWith(
          EscalationPolicy value, $Res Function(EscalationPolicy) then) =
      _$EscalationPolicyCopyWithImpl<$Res, EscalationPolicy>;
  @useResult
  $Res call(
      {int maxSnoozes,
      int snoozeBaseDelayMinutes,
      int responseWindowSeconds,
      int maxEscalations,
      int escalationIntervalSeconds,
      int confirmationWindowSeconds});
}

/// @nodoc
class _$EscalationPolicyCopyWithImpl<$Res, $Val extends EscalationPolicy>
    implements $EscalationPolicyCopyWith<$Res> {
  _$EscalationPolicyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EscalationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSnoozes = null,
    Object? snoozeBaseDelayMinutes = null,
    Object? responseWindowSeconds = null,
    Object? maxEscalations = null,
    Object? escalationIntervalSeconds = null,
    Object? confirmationWindowSeconds = null,
  }) {
    return _then(_value.copyWith(
      maxSnoozes: null == maxSnoozes
          ? _value.maxSnoozes
          : maxSnoozes // ignore: cast_nullable_to_non_nullable
              as int,
      snoozeBaseDelayMinutes: null == snoozeBaseDelayMinutes
          ? _value.snoozeBaseDelayMinutes
          : snoozeBaseDelayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      responseWindowSeconds: null == responseWindowSeconds
          ? _value.responseWindowSeconds
          : responseWindowSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxEscalations: null == maxEscalations
          ? _value.maxEscalations
          : maxEscalations // ignore: cast_nullable_to_non_nullable
              as int,
      escalationIntervalSeconds: null == escalationIntervalSeconds
          ? _value.escalationIntervalSeconds
          : escalationIntervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationWindowSeconds: null == confirmationWindowSeconds
          ? _value.confirmationWindowSeconds
          : confirmationWindowSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EscalationPolicyImplCopyWith<$Res>
    implements $EscalationPolicyCopyWith<$Res> {
  factory _$$EscalationPolicyImplCopyWith(_$EscalationPolicyImpl value,
          $Res Function(_$EscalationPolicyImpl) then) =
      __$$EscalationPolicyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int maxSnoozes,
      int snoozeBaseDelayMinutes,
      int responseWindowSeconds,
      int maxEscalations,
      int escalationIntervalSeconds,
      int confirmationWindowSeconds});
}

/// @nodoc
class __$$EscalationPolicyImplCopyWithImpl<$Res>
    extends _$EscalationPolicyCopyWithImpl<$Res, _$EscalationPolicyImpl>
    implements _$$EscalationPolicyImplCopyWith<$Res> {
  __$$EscalationPolicyImplCopyWithImpl(_$EscalationPolicyImpl _value,
      $Res Function(_$EscalationPolicyImpl) _then)
      : super(_value, _then);

  /// Create a copy of EscalationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxSnoozes = null,
    Object? snoozeBaseDelayMinutes = null,
    Object? responseWindowSeconds = null,
    Object? maxEscalations = null,
    Object? escalationIntervalSeconds = null,
    Object? confirmationWindowSeconds = null,
  }) {
    return _then(_$EscalationPolicyImpl(
      maxSnoozes: null == maxSnoozes
          ? _value.maxSnoozes
          : maxSnoozes // ignore: cast_nullable_to_non_nullable
              as int,
      snoozeBaseDelayMinutes: null == snoozeBaseDelayMinutes
          ? _value.snoozeBaseDelayMinutes
          : snoozeBaseDelayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      responseWindowSeconds: null == responseWindowSeconds
          ? _value.responseWindowSeconds
          : responseWindowSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      maxEscalations: null == maxEscalations
          ? _value.maxEscalations
          : maxEscalations // ignore: cast_nullable_to_non_nullable
              as int,
      escalationIntervalSeconds: null == escalationIntervalSeconds
          ? _value.escalationIntervalSeconds
          : escalationIntervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationWindowSeconds: null == confirmationWindowSeconds
          ? _value.confirmationWindowSeconds
          : confirmationWindowSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$EscalationPolicyImpl extends _EscalationPolicy {
  const _$EscalationPolicyImpl(
      {this.maxSnoozes = 3,
      this.snoozeBaseDelayMinutes = 5,
      this.responseWindowSeconds = 300,
      this.maxEscalations = 3,
      this.escalationIntervalSeconds = 600,
      this.confirmationWindowSeconds = 30})
      : super._();

  @override
  @JsonKey()
  final int maxSnoozes;
  @override
  @JsonKey()
  final int snoozeBaseDelayMinutes;
  @override
  @JsonKey()
  final int responseWindowSeconds;
  @override
  @JsonKey()
  final int maxEscalations;
  @override
  @JsonKey()
  final int escalationIntervalSeconds;
  @override
  @JsonKey()
  final int confirmationWindowSeconds;

  @override
  String toString() {
    return 'EscalationPolicy(maxSnoozes: $maxSnoozes, snoozeBaseDelayMinutes: $snoozeBaseDelayMinutes, responseWindowSeconds: $responseWindowSeconds, maxEscalations: $maxEscalations, escalationIntervalSeconds: $escalationIntervalSeconds, confirmationWindowSeconds: $confirmationWindowSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscalationPolicyImpl &&
            (identical(other.maxSnoozes, maxSnoozes) ||
                other.maxSnoozes == maxSnoozes) &&
            (identical(other.snoozeBaseDelayMinutes, snoozeBaseDelayMinutes) ||
                other.snoozeBaseDelayMinutes == snoozeBaseDelayMinutes) &&
            (identical(other.responseWindowSeconds, responseWindowSeconds) ||
                other.responseWindowSeconds == responseWindowSeconds) &&
            (identical(other.maxEscalations, maxEscalations) ||
                other.maxEscalations == maxEscalations) &&
            (identical(other.escalationIntervalSeconds,
                    escalationIntervalSeconds) ||
                other.escalationIntervalSeconds == escalationIntervalSeconds) &&
            (identical(other.confirmationWindowSeconds,
                    confirmationWindowSeconds) ||
                other.confirmationWindowSeconds == confirmationWindowSeconds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxSnoozes,
      snoozeBaseDelayMinutes,
      responseWindowSeconds,
      maxEscalations,
      escalationIntervalSeconds,
      confirmationWindowSeconds);

  /// Create a copy of EscalationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EscalationPolicyImplCopyWith<_$EscalationPolicyImpl> get copyWith =>
      __$$EscalationPolicyImplCopyWithImpl<_$EscalationPolicyImpl>(
          this, _$identity);
}

abstract class _EscalationPolicy extends EscalationPolicy {
  const factory _EscalationPolicy(
      {final int maxSnoozes,
      final int snoozeBaseDelayMinutes,
      final int responseWindowSeconds,
      final int maxEscalations,
      final int escalationIntervalSeconds,
      final int confirmationWindowSeconds}) = _$EscalationPolicyImpl;
  const _EscalationPolicy._() : super._();

  @override
  int get maxSnoozes;
  @override
  int get snoozeBaseDelayMinutes;
  @override
  int get responseWindowSeconds;
  @override
  int get maxEscalations;
  @override
  int get escalationIntervalSeconds;
  @override
  int get confirmationWindowSeconds;

  /// Create a copy of EscalationPolicy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EscalationPolicyImplCopyWith<_$EscalationPolicyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
