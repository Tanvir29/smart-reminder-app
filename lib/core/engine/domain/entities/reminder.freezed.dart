// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Reminder {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  ReminderStatus get status => throw _privateConstructorUsedError;
  int get scheduledTime => throw _privateConstructorUsedError;
  int? get actualTriggerTime => throw _privateConstructorUsedError;
  int get snoozeCount => throw _privateConstructorUsedError;
  int get escalationCount => throw _privateConstructorUsedError;
  String get confirmationMode => throw _privateConstructorUsedError;
  String? get linkedEntityId => throw _privateConstructorUsedError;
  String? get linkedEntityType => throw _privateConstructorUsedError;
  EscalationPolicy get policy => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get updatedAt => throw _privateConstructorUsedError;
  int? get completedAt => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get xpValue => throw _privateConstructorUsedError;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderCopyWith<Reminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCopyWith<$Res> {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) then) =
      _$ReminderCopyWithImpl<$Res, Reminder>;
  @useResult
  $Res call(
      {String id,
      String profileId,
      String type,
      String title,
      String? body,
      ReminderStatus status,
      int scheduledTime,
      int? actualTriggerTime,
      int snoozeCount,
      int escalationCount,
      String confirmationMode,
      String? linkedEntityId,
      String? linkedEntityType,
      EscalationPolicy policy,
      int createdAt,
      int updatedAt,
      int? completedAt,
      String? cancellationReason,
      String syncStatus,
      int xpValue});

  $EscalationPolicyCopyWith<$Res> get policy;
}

/// @nodoc
class _$ReminderCopyWithImpl<$Res, $Val extends Reminder>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? status = null,
    Object? scheduledTime = null,
    Object? actualTriggerTime = freezed,
    Object? snoozeCount = null,
    Object? escalationCount = null,
    Object? confirmationMode = null,
    Object? linkedEntityId = freezed,
    Object? linkedEntityType = freezed,
    Object? policy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? cancellationReason = freezed,
    Object? syncStatus = null,
    Object? xpValue = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReminderStatus,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as int,
      actualTriggerTime: freezed == actualTriggerTime
          ? _value.actualTriggerTime
          : actualTriggerTime // ignore: cast_nullable_to_non_nullable
              as int?,
      snoozeCount: null == snoozeCount
          ? _value.snoozeCount
          : snoozeCount // ignore: cast_nullable_to_non_nullable
              as int,
      escalationCount: null == escalationCount
          ? _value.escalationCount
          : escalationCount // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationMode: null == confirmationMode
          ? _value.confirmationMode
          : confirmationMode // ignore: cast_nullable_to_non_nullable
              as String,
      linkedEntityId: freezed == linkedEntityId
          ? _value.linkedEntityId
          : linkedEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedEntityType: freezed == linkedEntityType
          ? _value.linkedEntityType
          : linkedEntityType // ignore: cast_nullable_to_non_nullable
              as String?,
      policy: null == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as EscalationPolicy,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      xpValue: null == xpValue
          ? _value.xpValue
          : xpValue // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EscalationPolicyCopyWith<$Res> get policy {
    return $EscalationPolicyCopyWith<$Res>(_value.policy, (value) {
      return _then(_value.copyWith(policy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReminderImplCopyWith<$Res>
    implements $ReminderCopyWith<$Res> {
  factory _$$ReminderImplCopyWith(
          _$ReminderImpl value, $Res Function(_$ReminderImpl) then) =
      __$$ReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String profileId,
      String type,
      String title,
      String? body,
      ReminderStatus status,
      int scheduledTime,
      int? actualTriggerTime,
      int snoozeCount,
      int escalationCount,
      String confirmationMode,
      String? linkedEntityId,
      String? linkedEntityType,
      EscalationPolicy policy,
      int createdAt,
      int updatedAt,
      int? completedAt,
      String? cancellationReason,
      String syncStatus,
      int xpValue});

  @override
  $EscalationPolicyCopyWith<$Res> get policy;
}

/// @nodoc
class __$$ReminderImplCopyWithImpl<$Res>
    extends _$ReminderCopyWithImpl<$Res, _$ReminderImpl>
    implements _$$ReminderImplCopyWith<$Res> {
  __$$ReminderImplCopyWithImpl(
      _$ReminderImpl _value, $Res Function(_$ReminderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? status = null,
    Object? scheduledTime = null,
    Object? actualTriggerTime = freezed,
    Object? snoozeCount = null,
    Object? escalationCount = null,
    Object? confirmationMode = null,
    Object? linkedEntityId = freezed,
    Object? linkedEntityType = freezed,
    Object? policy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? cancellationReason = freezed,
    Object? syncStatus = null,
    Object? xpValue = null,
  }) {
    return _then(_$ReminderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReminderStatus,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as int,
      actualTriggerTime: freezed == actualTriggerTime
          ? _value.actualTriggerTime
          : actualTriggerTime // ignore: cast_nullable_to_non_nullable
              as int?,
      snoozeCount: null == snoozeCount
          ? _value.snoozeCount
          : snoozeCount // ignore: cast_nullable_to_non_nullable
              as int,
      escalationCount: null == escalationCount
          ? _value.escalationCount
          : escalationCount // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationMode: null == confirmationMode
          ? _value.confirmationMode
          : confirmationMode // ignore: cast_nullable_to_non_nullable
              as String,
      linkedEntityId: freezed == linkedEntityId
          ? _value.linkedEntityId
          : linkedEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedEntityType: freezed == linkedEntityType
          ? _value.linkedEntityType
          : linkedEntityType // ignore: cast_nullable_to_non_nullable
              as String?,
      policy: null == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as EscalationPolicy,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      xpValue: null == xpValue
          ? _value.xpValue
          : xpValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ReminderImpl extends _Reminder {
  const _$ReminderImpl(
      {required this.id,
      required this.profileId,
      required this.type,
      required this.title,
      this.body,
      required this.status,
      required this.scheduledTime,
      this.actualTriggerTime,
      this.snoozeCount = 0,
      this.escalationCount = 0,
      this.confirmationMode = 'swipeToConfirm',
      this.linkedEntityId,
      this.linkedEntityType,
      required this.policy,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt,
      this.cancellationReason,
      this.syncStatus = 'local',
      this.xpValue = 10})
      : super._();

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String? body;
  @override
  final ReminderStatus status;
  @override
  final int scheduledTime;
  @override
  final int? actualTriggerTime;
  @override
  @JsonKey()
  final int snoozeCount;
  @override
  @JsonKey()
  final int escalationCount;
  @override
  @JsonKey()
  final String confirmationMode;
  @override
  final String? linkedEntityId;
  @override
  final String? linkedEntityType;
  @override
  final EscalationPolicy policy;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int? completedAt;
  @override
  final String? cancellationReason;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  @JsonKey()
  final int xpValue;

  @override
  String toString() {
    return 'Reminder(id: $id, profileId: $profileId, type: $type, title: $title, body: $body, status: $status, scheduledTime: $scheduledTime, actualTriggerTime: $actualTriggerTime, snoozeCount: $snoozeCount, escalationCount: $escalationCount, confirmationMode: $confirmationMode, linkedEntityId: $linkedEntityId, linkedEntityType: $linkedEntityType, policy: $policy, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, cancellationReason: $cancellationReason, syncStatus: $syncStatus, xpValue: $xpValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.actualTriggerTime, actualTriggerTime) ||
                other.actualTriggerTime == actualTriggerTime) &&
            (identical(other.snoozeCount, snoozeCount) ||
                other.snoozeCount == snoozeCount) &&
            (identical(other.escalationCount, escalationCount) ||
                other.escalationCount == escalationCount) &&
            (identical(other.confirmationMode, confirmationMode) ||
                other.confirmationMode == confirmationMode) &&
            (identical(other.linkedEntityId, linkedEntityId) ||
                other.linkedEntityId == linkedEntityId) &&
            (identical(other.linkedEntityType, linkedEntityType) ||
                other.linkedEntityType == linkedEntityType) &&
            (identical(other.policy, policy) || other.policy == policy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.xpValue, xpValue) || other.xpValue == xpValue));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        profileId,
        type,
        title,
        body,
        status,
        scheduledTime,
        actualTriggerTime,
        snoozeCount,
        escalationCount,
        confirmationMode,
        linkedEntityId,
        linkedEntityType,
        policy,
        createdAt,
        updatedAt,
        completedAt,
        cancellationReason,
        syncStatus,
        xpValue
      ]);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      __$$ReminderImplCopyWithImpl<_$ReminderImpl>(this, _$identity);
}

abstract class _Reminder extends Reminder {
  const factory _Reminder(
      {required final String id,
      required final String profileId,
      required final String type,
      required final String title,
      final String? body,
      required final ReminderStatus status,
      required final int scheduledTime,
      final int? actualTriggerTime,
      final int snoozeCount,
      final int escalationCount,
      final String confirmationMode,
      final String? linkedEntityId,
      final String? linkedEntityType,
      required final EscalationPolicy policy,
      required final int createdAt,
      required final int updatedAt,
      final int? completedAt,
      final String? cancellationReason,
      final String syncStatus,
      final int xpValue}) = _$ReminderImpl;
  const _Reminder._() : super._();

  @override
  String get id;
  @override
  String get profileId;
  @override
  String get type;
  @override
  String get title;
  @override
  String? get body;
  @override
  ReminderStatus get status;
  @override
  int get scheduledTime;
  @override
  int? get actualTriggerTime;
  @override
  int get snoozeCount;
  @override
  int get escalationCount;
  @override
  String get confirmationMode;
  @override
  String? get linkedEntityId;
  @override
  String? get linkedEntityType;
  @override
  EscalationPolicy get policy;
  @override
  int get createdAt;
  @override
  int get updatedAt;
  @override
  int? get completedAt;
  @override
  String? get cancellationReason;
  @override
  String get syncStatus;
  @override
  int get xpValue;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
