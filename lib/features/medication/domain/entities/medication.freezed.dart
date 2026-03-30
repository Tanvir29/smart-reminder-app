// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicationFrequency _$MedicationFrequencyFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'daily':
      return DailyFrequency.fromJson(json);
    case 'weekly':
      return WeeklyFrequency.fromJson(json);
    case 'interval':
      return IntervalFrequency.fromJson(json);
    case 'asNeeded':
      return AsNeededFrequency.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MedicationFrequency',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MedicationFrequency {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<int> timesOfDay) daily,
    required TResult Function(List<int> timesOfDay, List<int> weekDays) weekly,
    required TResult Function(int intervalHours) interval,
    required TResult Function() asNeeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<int> timesOfDay)? daily,
    TResult? Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult? Function(int intervalHours)? interval,
    TResult? Function()? asNeeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<int> timesOfDay)? daily,
    TResult Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult Function(int intervalHours)? interval,
    TResult Function()? asNeeded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyFrequency value) daily,
    required TResult Function(WeeklyFrequency value) weekly,
    required TResult Function(IntervalFrequency value) interval,
    required TResult Function(AsNeededFrequency value) asNeeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyFrequency value)? daily,
    TResult? Function(WeeklyFrequency value)? weekly,
    TResult? Function(IntervalFrequency value)? interval,
    TResult? Function(AsNeededFrequency value)? asNeeded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyFrequency value)? daily,
    TResult Function(WeeklyFrequency value)? weekly,
    TResult Function(IntervalFrequency value)? interval,
    TResult Function(AsNeededFrequency value)? asNeeded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MedicationFrequency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationFrequencyCopyWith<$Res> {
  factory $MedicationFrequencyCopyWith(
          MedicationFrequency value, $Res Function(MedicationFrequency) then) =
      _$MedicationFrequencyCopyWithImpl<$Res, MedicationFrequency>;
}

/// @nodoc
class _$MedicationFrequencyCopyWithImpl<$Res, $Val extends MedicationFrequency>
    implements $MedicationFrequencyCopyWith<$Res> {
  _$MedicationFrequencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DailyFrequencyImplCopyWith<$Res> {
  factory _$$DailyFrequencyImplCopyWith(_$DailyFrequencyImpl value,
          $Res Function(_$DailyFrequencyImpl) then) =
      __$$DailyFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> timesOfDay});
}

/// @nodoc
class __$$DailyFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$DailyFrequencyImpl>
    implements _$$DailyFrequencyImplCopyWith<$Res> {
  __$$DailyFrequencyImplCopyWithImpl(
      _$DailyFrequencyImpl _value, $Res Function(_$DailyFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timesOfDay = null,
  }) {
    return _then(_$DailyFrequencyImpl(
      timesOfDay: null == timesOfDay
          ? _value._timesOfDay
          : timesOfDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyFrequencyImpl implements DailyFrequency {
  const _$DailyFrequencyImpl(
      {required final List<int> timesOfDay, final String? $type})
      : _timesOfDay = timesOfDay,
        $type = $type ?? 'daily';

  factory _$DailyFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyFrequencyImplFromJson(json);

  final List<int> _timesOfDay;
  @override
  List<int> get timesOfDay {
    if (_timesOfDay is EqualUnmodifiableListView) return _timesOfDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timesOfDay);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.daily(timesOfDay: $timesOfDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyFrequencyImpl &&
            const DeepCollectionEquality()
                .equals(other._timesOfDay, _timesOfDay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_timesOfDay));

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyFrequencyImplCopyWith<_$DailyFrequencyImpl> get copyWith =>
      __$$DailyFrequencyImplCopyWithImpl<_$DailyFrequencyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<int> timesOfDay) daily,
    required TResult Function(List<int> timesOfDay, List<int> weekDays) weekly,
    required TResult Function(int intervalHours) interval,
    required TResult Function() asNeeded,
  }) {
    return daily(timesOfDay);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<int> timesOfDay)? daily,
    TResult? Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult? Function(int intervalHours)? interval,
    TResult? Function()? asNeeded,
  }) {
    return daily?.call(timesOfDay);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<int> timesOfDay)? daily,
    TResult Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult Function(int intervalHours)? interval,
    TResult Function()? asNeeded,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily(timesOfDay);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyFrequency value) daily,
    required TResult Function(WeeklyFrequency value) weekly,
    required TResult Function(IntervalFrequency value) interval,
    required TResult Function(AsNeededFrequency value) asNeeded,
  }) {
    return daily(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyFrequency value)? daily,
    TResult? Function(WeeklyFrequency value)? weekly,
    TResult? Function(IntervalFrequency value)? interval,
    TResult? Function(AsNeededFrequency value)? asNeeded,
  }) {
    return daily?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyFrequency value)? daily,
    TResult Function(WeeklyFrequency value)? weekly,
    TResult Function(IntervalFrequency value)? interval,
    TResult Function(AsNeededFrequency value)? asNeeded,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyFrequencyImplToJson(
      this,
    );
  }
}

abstract class DailyFrequency implements MedicationFrequency {
  const factory DailyFrequency({required final List<int> timesOfDay}) =
      _$DailyFrequencyImpl;

  factory DailyFrequency.fromJson(Map<String, dynamic> json) =
      _$DailyFrequencyImpl.fromJson;

  List<int> get timesOfDay;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyFrequencyImplCopyWith<_$DailyFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WeeklyFrequencyImplCopyWith<$Res> {
  factory _$$WeeklyFrequencyImplCopyWith(_$WeeklyFrequencyImpl value,
          $Res Function(_$WeeklyFrequencyImpl) then) =
      __$$WeeklyFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> timesOfDay, List<int> weekDays});
}

/// @nodoc
class __$$WeeklyFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$WeeklyFrequencyImpl>
    implements _$$WeeklyFrequencyImplCopyWith<$Res> {
  __$$WeeklyFrequencyImplCopyWithImpl(
      _$WeeklyFrequencyImpl _value, $Res Function(_$WeeklyFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timesOfDay = null,
    Object? weekDays = null,
  }) {
    return _then(_$WeeklyFrequencyImpl(
      timesOfDay: null == timesOfDay
          ? _value._timesOfDay
          : timesOfDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      weekDays: null == weekDays
          ? _value._weekDays
          : weekDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyFrequencyImpl implements WeeklyFrequency {
  const _$WeeklyFrequencyImpl(
      {required final List<int> timesOfDay,
      required final List<int> weekDays,
      final String? $type})
      : _timesOfDay = timesOfDay,
        _weekDays = weekDays,
        $type = $type ?? 'weekly';

  factory _$WeeklyFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyFrequencyImplFromJson(json);

  final List<int> _timesOfDay;
  @override
  List<int> get timesOfDay {
    if (_timesOfDay is EqualUnmodifiableListView) return _timesOfDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timesOfDay);
  }

// minutes from midnight
  final List<int> _weekDays;
// minutes from midnight
  @override
  List<int> get weekDays {
    if (_weekDays is EqualUnmodifiableListView) return _weekDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekDays);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.weekly(timesOfDay: $timesOfDay, weekDays: $weekDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyFrequencyImpl &&
            const DeepCollectionEquality()
                .equals(other._timesOfDay, _timesOfDay) &&
            const DeepCollectionEquality().equals(other._weekDays, _weekDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timesOfDay),
      const DeepCollectionEquality().hash(_weekDays));

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyFrequencyImplCopyWith<_$WeeklyFrequencyImpl> get copyWith =>
      __$$WeeklyFrequencyImplCopyWithImpl<_$WeeklyFrequencyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<int> timesOfDay) daily,
    required TResult Function(List<int> timesOfDay, List<int> weekDays) weekly,
    required TResult Function(int intervalHours) interval,
    required TResult Function() asNeeded,
  }) {
    return weekly(timesOfDay, weekDays);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<int> timesOfDay)? daily,
    TResult? Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult? Function(int intervalHours)? interval,
    TResult? Function()? asNeeded,
  }) {
    return weekly?.call(timesOfDay, weekDays);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<int> timesOfDay)? daily,
    TResult Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult Function(int intervalHours)? interval,
    TResult Function()? asNeeded,
    required TResult orElse(),
  }) {
    if (weekly != null) {
      return weekly(timesOfDay, weekDays);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyFrequency value) daily,
    required TResult Function(WeeklyFrequency value) weekly,
    required TResult Function(IntervalFrequency value) interval,
    required TResult Function(AsNeededFrequency value) asNeeded,
  }) {
    return weekly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyFrequency value)? daily,
    TResult? Function(WeeklyFrequency value)? weekly,
    TResult? Function(IntervalFrequency value)? interval,
    TResult? Function(AsNeededFrequency value)? asNeeded,
  }) {
    return weekly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyFrequency value)? daily,
    TResult Function(WeeklyFrequency value)? weekly,
    TResult Function(IntervalFrequency value)? interval,
    TResult Function(AsNeededFrequency value)? asNeeded,
    required TResult orElse(),
  }) {
    if (weekly != null) {
      return weekly(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyFrequencyImplToJson(
      this,
    );
  }
}

abstract class WeeklyFrequency implements MedicationFrequency {
  const factory WeeklyFrequency(
      {required final List<int> timesOfDay,
      required final List<int> weekDays}) = _$WeeklyFrequencyImpl;

  factory WeeklyFrequency.fromJson(Map<String, dynamic> json) =
      _$WeeklyFrequencyImpl.fromJson;

  List<int> get timesOfDay; // minutes from midnight
  List<int> get weekDays;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyFrequencyImplCopyWith<_$WeeklyFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntervalFrequencyImplCopyWith<$Res> {
  factory _$$IntervalFrequencyImplCopyWith(_$IntervalFrequencyImpl value,
          $Res Function(_$IntervalFrequencyImpl) then) =
      __$$IntervalFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int intervalHours});
}

/// @nodoc
class __$$IntervalFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$IntervalFrequencyImpl>
    implements _$$IntervalFrequencyImplCopyWith<$Res> {
  __$$IntervalFrequencyImplCopyWithImpl(_$IntervalFrequencyImpl _value,
      $Res Function(_$IntervalFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? intervalHours = null,
  }) {
    return _then(_$IntervalFrequencyImpl(
      intervalHours: null == intervalHours
          ? _value.intervalHours
          : intervalHours // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntervalFrequencyImpl implements IntervalFrequency {
  const _$IntervalFrequencyImpl(
      {required this.intervalHours, final String? $type})
      : $type = $type ?? 'interval';

  factory _$IntervalFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntervalFrequencyImplFromJson(json);

  @override
  final int intervalHours;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.interval(intervalHours: $intervalHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntervalFrequencyImpl &&
            (identical(other.intervalHours, intervalHours) ||
                other.intervalHours == intervalHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, intervalHours);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IntervalFrequencyImplCopyWith<_$IntervalFrequencyImpl> get copyWith =>
      __$$IntervalFrequencyImplCopyWithImpl<_$IntervalFrequencyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<int> timesOfDay) daily,
    required TResult Function(List<int> timesOfDay, List<int> weekDays) weekly,
    required TResult Function(int intervalHours) interval,
    required TResult Function() asNeeded,
  }) {
    return interval(intervalHours);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<int> timesOfDay)? daily,
    TResult? Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult? Function(int intervalHours)? interval,
    TResult? Function()? asNeeded,
  }) {
    return interval?.call(intervalHours);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<int> timesOfDay)? daily,
    TResult Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult Function(int intervalHours)? interval,
    TResult Function()? asNeeded,
    required TResult orElse(),
  }) {
    if (interval != null) {
      return interval(intervalHours);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyFrequency value) daily,
    required TResult Function(WeeklyFrequency value) weekly,
    required TResult Function(IntervalFrequency value) interval,
    required TResult Function(AsNeededFrequency value) asNeeded,
  }) {
    return interval(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyFrequency value)? daily,
    TResult? Function(WeeklyFrequency value)? weekly,
    TResult? Function(IntervalFrequency value)? interval,
    TResult? Function(AsNeededFrequency value)? asNeeded,
  }) {
    return interval?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyFrequency value)? daily,
    TResult Function(WeeklyFrequency value)? weekly,
    TResult Function(IntervalFrequency value)? interval,
    TResult Function(AsNeededFrequency value)? asNeeded,
    required TResult orElse(),
  }) {
    if (interval != null) {
      return interval(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IntervalFrequencyImplToJson(
      this,
    );
  }
}

abstract class IntervalFrequency implements MedicationFrequency {
  const factory IntervalFrequency({required final int intervalHours}) =
      _$IntervalFrequencyImpl;

  factory IntervalFrequency.fromJson(Map<String, dynamic> json) =
      _$IntervalFrequencyImpl.fromJson;

  int get intervalHours;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IntervalFrequencyImplCopyWith<_$IntervalFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AsNeededFrequencyImplCopyWith<$Res> {
  factory _$$AsNeededFrequencyImplCopyWith(_$AsNeededFrequencyImpl value,
          $Res Function(_$AsNeededFrequencyImpl) then) =
      __$$AsNeededFrequencyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AsNeededFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$AsNeededFrequencyImpl>
    implements _$$AsNeededFrequencyImplCopyWith<$Res> {
  __$$AsNeededFrequencyImplCopyWithImpl(_$AsNeededFrequencyImpl _value,
      $Res Function(_$AsNeededFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$AsNeededFrequencyImpl implements AsNeededFrequency {
  const _$AsNeededFrequencyImpl({final String? $type})
      : $type = $type ?? 'asNeeded';

  factory _$AsNeededFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AsNeededFrequencyImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.asNeeded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AsNeededFrequencyImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<int> timesOfDay) daily,
    required TResult Function(List<int> timesOfDay, List<int> weekDays) weekly,
    required TResult Function(int intervalHours) interval,
    required TResult Function() asNeeded,
  }) {
    return asNeeded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<int> timesOfDay)? daily,
    TResult? Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult? Function(int intervalHours)? interval,
    TResult? Function()? asNeeded,
  }) {
    return asNeeded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<int> timesOfDay)? daily,
    TResult Function(List<int> timesOfDay, List<int> weekDays)? weekly,
    TResult Function(int intervalHours)? interval,
    TResult Function()? asNeeded,
    required TResult orElse(),
  }) {
    if (asNeeded != null) {
      return asNeeded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyFrequency value) daily,
    required TResult Function(WeeklyFrequency value) weekly,
    required TResult Function(IntervalFrequency value) interval,
    required TResult Function(AsNeededFrequency value) asNeeded,
  }) {
    return asNeeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyFrequency value)? daily,
    TResult? Function(WeeklyFrequency value)? weekly,
    TResult? Function(IntervalFrequency value)? interval,
    TResult? Function(AsNeededFrequency value)? asNeeded,
  }) {
    return asNeeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyFrequency value)? daily,
    TResult Function(WeeklyFrequency value)? weekly,
    TResult Function(IntervalFrequency value)? interval,
    TResult Function(AsNeededFrequency value)? asNeeded,
    required TResult orElse(),
  }) {
    if (asNeeded != null) {
      return asNeeded(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AsNeededFrequencyImplToJson(
      this,
    );
  }
}

abstract class AsNeededFrequency implements MedicationFrequency {
  const factory AsNeededFrequency() = _$AsNeededFrequencyImpl;

  factory AsNeededFrequency.fromJson(Map<String, dynamic> json) =
      _$AsNeededFrequencyImpl.fromJson;
}

ReminderDuration _$ReminderDurationFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'fixedDays':
      return FixedDaysDuration.fromJson(json);
    case 'oneMonth':
      return OneMonthDuration.fromJson(json);
    case 'continuous':
      return ContinuousDuration.fromJson(json);
    case 'custom':
      return CustomDuration.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ReminderDuration',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ReminderDuration {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) fixedDays,
    required TResult Function() oneMonth,
    required TResult Function() continuous,
    required TResult Function(int endTime) custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? fixedDays,
    TResult? Function()? oneMonth,
    TResult? Function()? continuous,
    TResult? Function(int endTime)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? fixedDays,
    TResult Function()? oneMonth,
    TResult Function()? continuous,
    TResult Function(int endTime)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FixedDaysDuration value) fixedDays,
    required TResult Function(OneMonthDuration value) oneMonth,
    required TResult Function(ContinuousDuration value) continuous,
    required TResult Function(CustomDuration value) custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FixedDaysDuration value)? fixedDays,
    TResult? Function(OneMonthDuration value)? oneMonth,
    TResult? Function(ContinuousDuration value)? continuous,
    TResult? Function(CustomDuration value)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FixedDaysDuration value)? fixedDays,
    TResult Function(OneMonthDuration value)? oneMonth,
    TResult Function(ContinuousDuration value)? continuous,
    TResult Function(CustomDuration value)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ReminderDuration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderDurationCopyWith<$Res> {
  factory $ReminderDurationCopyWith(
          ReminderDuration value, $Res Function(ReminderDuration) then) =
      _$ReminderDurationCopyWithImpl<$Res, ReminderDuration>;
}

/// @nodoc
class _$ReminderDurationCopyWithImpl<$Res, $Val extends ReminderDuration>
    implements $ReminderDurationCopyWith<$Res> {
  _$ReminderDurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FixedDaysDurationImplCopyWith<$Res> {
  factory _$$FixedDaysDurationImplCopyWith(_$FixedDaysDurationImpl value,
          $Res Function(_$FixedDaysDurationImpl) then) =
      __$$FixedDaysDurationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int days});
}

/// @nodoc
class __$$FixedDaysDurationImplCopyWithImpl<$Res>
    extends _$ReminderDurationCopyWithImpl<$Res, _$FixedDaysDurationImpl>
    implements _$$FixedDaysDurationImplCopyWith<$Res> {
  __$$FixedDaysDurationImplCopyWithImpl(_$FixedDaysDurationImpl _value,
      $Res Function(_$FixedDaysDurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
  }) {
    return _then(_$FixedDaysDurationImpl(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedDaysDurationImpl implements FixedDaysDuration {
  const _$FixedDaysDurationImpl({this.days = 7, final String? $type})
      : $type = $type ?? 'fixedDays';

  factory _$FixedDaysDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedDaysDurationImplFromJson(json);

  @override
  @JsonKey()
  final int days;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReminderDuration.fixedDays(days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedDaysDurationImpl &&
            (identical(other.days, days) || other.days == days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, days);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedDaysDurationImplCopyWith<_$FixedDaysDurationImpl> get copyWith =>
      __$$FixedDaysDurationImplCopyWithImpl<_$FixedDaysDurationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) fixedDays,
    required TResult Function() oneMonth,
    required TResult Function() continuous,
    required TResult Function(int endTime) custom,
  }) {
    return fixedDays(days);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? fixedDays,
    TResult? Function()? oneMonth,
    TResult? Function()? continuous,
    TResult? Function(int endTime)? custom,
  }) {
    return fixedDays?.call(days);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? fixedDays,
    TResult Function()? oneMonth,
    TResult Function()? continuous,
    TResult Function(int endTime)? custom,
    required TResult orElse(),
  }) {
    if (fixedDays != null) {
      return fixedDays(days);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FixedDaysDuration value) fixedDays,
    required TResult Function(OneMonthDuration value) oneMonth,
    required TResult Function(ContinuousDuration value) continuous,
    required TResult Function(CustomDuration value) custom,
  }) {
    return fixedDays(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FixedDaysDuration value)? fixedDays,
    TResult? Function(OneMonthDuration value)? oneMonth,
    TResult? Function(ContinuousDuration value)? continuous,
    TResult? Function(CustomDuration value)? custom,
  }) {
    return fixedDays?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FixedDaysDuration value)? fixedDays,
    TResult Function(OneMonthDuration value)? oneMonth,
    TResult Function(ContinuousDuration value)? continuous,
    TResult Function(CustomDuration value)? custom,
    required TResult orElse(),
  }) {
    if (fixedDays != null) {
      return fixedDays(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedDaysDurationImplToJson(
      this,
    );
  }
}

abstract class FixedDaysDuration implements ReminderDuration {
  const factory FixedDaysDuration({final int days}) = _$FixedDaysDurationImpl;

  factory FixedDaysDuration.fromJson(Map<String, dynamic> json) =
      _$FixedDaysDurationImpl.fromJson;

  int get days;

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedDaysDurationImplCopyWith<_$FixedDaysDurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OneMonthDurationImplCopyWith<$Res> {
  factory _$$OneMonthDurationImplCopyWith(_$OneMonthDurationImpl value,
          $Res Function(_$OneMonthDurationImpl) then) =
      __$$OneMonthDurationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OneMonthDurationImplCopyWithImpl<$Res>
    extends _$ReminderDurationCopyWithImpl<$Res, _$OneMonthDurationImpl>
    implements _$$OneMonthDurationImplCopyWith<$Res> {
  __$$OneMonthDurationImplCopyWithImpl(_$OneMonthDurationImpl _value,
      $Res Function(_$OneMonthDurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$OneMonthDurationImpl implements OneMonthDuration {
  const _$OneMonthDurationImpl({final String? $type})
      : $type = $type ?? 'oneMonth';

  factory _$OneMonthDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$OneMonthDurationImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReminderDuration.oneMonth()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OneMonthDurationImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) fixedDays,
    required TResult Function() oneMonth,
    required TResult Function() continuous,
    required TResult Function(int endTime) custom,
  }) {
    return oneMonth();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? fixedDays,
    TResult? Function()? oneMonth,
    TResult? Function()? continuous,
    TResult? Function(int endTime)? custom,
  }) {
    return oneMonth?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? fixedDays,
    TResult Function()? oneMonth,
    TResult Function()? continuous,
    TResult Function(int endTime)? custom,
    required TResult orElse(),
  }) {
    if (oneMonth != null) {
      return oneMonth();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FixedDaysDuration value) fixedDays,
    required TResult Function(OneMonthDuration value) oneMonth,
    required TResult Function(ContinuousDuration value) continuous,
    required TResult Function(CustomDuration value) custom,
  }) {
    return oneMonth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FixedDaysDuration value)? fixedDays,
    TResult? Function(OneMonthDuration value)? oneMonth,
    TResult? Function(ContinuousDuration value)? continuous,
    TResult? Function(CustomDuration value)? custom,
  }) {
    return oneMonth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FixedDaysDuration value)? fixedDays,
    TResult Function(OneMonthDuration value)? oneMonth,
    TResult Function(ContinuousDuration value)? continuous,
    TResult Function(CustomDuration value)? custom,
    required TResult orElse(),
  }) {
    if (oneMonth != null) {
      return oneMonth(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OneMonthDurationImplToJson(
      this,
    );
  }
}

abstract class OneMonthDuration implements ReminderDuration {
  const factory OneMonthDuration() = _$OneMonthDurationImpl;

  factory OneMonthDuration.fromJson(Map<String, dynamic> json) =
      _$OneMonthDurationImpl.fromJson;
}

/// @nodoc
abstract class _$$ContinuousDurationImplCopyWith<$Res> {
  factory _$$ContinuousDurationImplCopyWith(_$ContinuousDurationImpl value,
          $Res Function(_$ContinuousDurationImpl) then) =
      __$$ContinuousDurationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ContinuousDurationImplCopyWithImpl<$Res>
    extends _$ReminderDurationCopyWithImpl<$Res, _$ContinuousDurationImpl>
    implements _$$ContinuousDurationImplCopyWith<$Res> {
  __$$ContinuousDurationImplCopyWithImpl(_$ContinuousDurationImpl _value,
      $Res Function(_$ContinuousDurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ContinuousDurationImpl implements ContinuousDuration {
  const _$ContinuousDurationImpl({final String? $type})
      : $type = $type ?? 'continuous';

  factory _$ContinuousDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContinuousDurationImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReminderDuration.continuous()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ContinuousDurationImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) fixedDays,
    required TResult Function() oneMonth,
    required TResult Function() continuous,
    required TResult Function(int endTime) custom,
  }) {
    return continuous();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? fixedDays,
    TResult? Function()? oneMonth,
    TResult? Function()? continuous,
    TResult? Function(int endTime)? custom,
  }) {
    return continuous?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? fixedDays,
    TResult Function()? oneMonth,
    TResult Function()? continuous,
    TResult Function(int endTime)? custom,
    required TResult orElse(),
  }) {
    if (continuous != null) {
      return continuous();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FixedDaysDuration value) fixedDays,
    required TResult Function(OneMonthDuration value) oneMonth,
    required TResult Function(ContinuousDuration value) continuous,
    required TResult Function(CustomDuration value) custom,
  }) {
    return continuous(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FixedDaysDuration value)? fixedDays,
    TResult? Function(OneMonthDuration value)? oneMonth,
    TResult? Function(ContinuousDuration value)? continuous,
    TResult? Function(CustomDuration value)? custom,
  }) {
    return continuous?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FixedDaysDuration value)? fixedDays,
    TResult Function(OneMonthDuration value)? oneMonth,
    TResult Function(ContinuousDuration value)? continuous,
    TResult Function(CustomDuration value)? custom,
    required TResult orElse(),
  }) {
    if (continuous != null) {
      return continuous(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ContinuousDurationImplToJson(
      this,
    );
  }
}

abstract class ContinuousDuration implements ReminderDuration {
  const factory ContinuousDuration() = _$ContinuousDurationImpl;

  factory ContinuousDuration.fromJson(Map<String, dynamic> json) =
      _$ContinuousDurationImpl.fromJson;
}

/// @nodoc
abstract class _$$CustomDurationImplCopyWith<$Res> {
  factory _$$CustomDurationImplCopyWith(_$CustomDurationImpl value,
          $Res Function(_$CustomDurationImpl) then) =
      __$$CustomDurationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int endTime});
}

/// @nodoc
class __$$CustomDurationImplCopyWithImpl<$Res>
    extends _$ReminderDurationCopyWithImpl<$Res, _$CustomDurationImpl>
    implements _$$CustomDurationImplCopyWith<$Res> {
  __$$CustomDurationImplCopyWithImpl(
      _$CustomDurationImpl _value, $Res Function(_$CustomDurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endTime = null,
  }) {
    return _then(_$CustomDurationImpl(
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomDurationImpl implements CustomDuration {
  const _$CustomDurationImpl({required this.endTime, final String? $type})
      : $type = $type ?? 'custom';

  factory _$CustomDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomDurationImplFromJson(json);

  @override
  final int endTime;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ReminderDuration.custom(endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomDurationImpl &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, endTime);

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomDurationImplCopyWith<_$CustomDurationImpl> get copyWith =>
      __$$CustomDurationImplCopyWithImpl<_$CustomDurationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int days) fixedDays,
    required TResult Function() oneMonth,
    required TResult Function() continuous,
    required TResult Function(int endTime) custom,
  }) {
    return custom(endTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int days)? fixedDays,
    TResult? Function()? oneMonth,
    TResult? Function()? continuous,
    TResult? Function(int endTime)? custom,
  }) {
    return custom?.call(endTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int days)? fixedDays,
    TResult Function()? oneMonth,
    TResult Function()? continuous,
    TResult Function(int endTime)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(endTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FixedDaysDuration value) fixedDays,
    required TResult Function(OneMonthDuration value) oneMonth,
    required TResult Function(ContinuousDuration value) continuous,
    required TResult Function(CustomDuration value) custom,
  }) {
    return custom(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FixedDaysDuration value)? fixedDays,
    TResult? Function(OneMonthDuration value)? oneMonth,
    TResult? Function(ContinuousDuration value)? continuous,
    TResult? Function(CustomDuration value)? custom,
  }) {
    return custom?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FixedDaysDuration value)? fixedDays,
    TResult Function(OneMonthDuration value)? oneMonth,
    TResult Function(ContinuousDuration value)? continuous,
    TResult Function(CustomDuration value)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomDurationImplToJson(
      this,
    );
  }
}

abstract class CustomDuration implements ReminderDuration {
  const factory CustomDuration({required final int endTime}) =
      _$CustomDurationImpl;

  factory CustomDuration.fromJson(Map<String, dynamic> json) =
      _$CustomDurationImpl.fromJson;

  int get endTime;

  /// Create a copy of ReminderDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomDurationImplCopyWith<_$CustomDurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Medication {
  String get id => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get dosage => throw _privateConstructorUsedError;
  MedicationFrequency get frequency => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  String? get reminderMessage => throw _privateConstructorUsedError;
  ReminderDuration get reminderDuration => throw _privateConstructorUsedError;
  bool get isCritical => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get updatedAt => throw _privateConstructorUsedError;
  int? get archivedAt => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get xpValue => throw _privateConstructorUsedError;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationCopyWith<Medication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationCopyWith<$Res> {
  factory $MedicationCopyWith(
          Medication value, $Res Function(Medication) then) =
      _$MedicationCopyWithImpl<$Res, Medication>;
  @useResult
  $Res call(
      {String id,
      String profileId,
      String name,
      String dosage,
      MedicationFrequency frequency,
      String? instructions,
      String? reminderMessage,
      ReminderDuration reminderDuration,
      bool isCritical,
      String iconName,
      String colorHex,
      bool isActive,
      int createdAt,
      int updatedAt,
      int? archivedAt,
      String syncStatus,
      int xpValue});

  $MedicationFrequencyCopyWith<$Res> get frequency;
  $ReminderDurationCopyWith<$Res> get reminderDuration;
}

/// @nodoc
class _$MedicationCopyWithImpl<$Res, $Val extends Medication>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? instructions = freezed,
    Object? reminderMessage = freezed,
    Object? reminderDuration = null,
    Object? isCritical = null,
    Object? iconName = null,
    Object? colorHex = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? archivedAt = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderMessage: freezed == reminderMessage
          ? _value.reminderMessage
          : reminderMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderDuration: null == reminderDuration
          ? _value.reminderDuration
          : reminderDuration // ignore: cast_nullable_to_non_nullable
              as ReminderDuration,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as int?,
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

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationFrequencyCopyWith<$Res> get frequency {
    return $MedicationFrequencyCopyWith<$Res>(_value.frequency, (value) {
      return _then(_value.copyWith(frequency: value) as $Val);
    });
  }

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReminderDurationCopyWith<$Res> get reminderDuration {
    return $ReminderDurationCopyWith<$Res>(_value.reminderDuration, (value) {
      return _then(_value.copyWith(reminderDuration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicationImplCopyWith<$Res>
    implements $MedicationCopyWith<$Res> {
  factory _$$MedicationImplCopyWith(
          _$MedicationImpl value, $Res Function(_$MedicationImpl) then) =
      __$$MedicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String profileId,
      String name,
      String dosage,
      MedicationFrequency frequency,
      String? instructions,
      String? reminderMessage,
      ReminderDuration reminderDuration,
      bool isCritical,
      String iconName,
      String colorHex,
      bool isActive,
      int createdAt,
      int updatedAt,
      int? archivedAt,
      String syncStatus,
      int xpValue});

  @override
  $MedicationFrequencyCopyWith<$Res> get frequency;
  @override
  $ReminderDurationCopyWith<$Res> get reminderDuration;
}

/// @nodoc
class __$$MedicationImplCopyWithImpl<$Res>
    extends _$MedicationCopyWithImpl<$Res, _$MedicationImpl>
    implements _$$MedicationImplCopyWith<$Res> {
  __$$MedicationImplCopyWithImpl(
      _$MedicationImpl _value, $Res Function(_$MedicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileId = null,
    Object? name = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? instructions = freezed,
    Object? reminderMessage = freezed,
    Object? reminderDuration = null,
    Object? isCritical = null,
    Object? iconName = null,
    Object? colorHex = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? archivedAt = freezed,
    Object? syncStatus = null,
    Object? xpValue = null,
  }) {
    return _then(_$MedicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderMessage: freezed == reminderMessage
          ? _value.reminderMessage
          : reminderMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderDuration: null == reminderDuration
          ? _value.reminderDuration
          : reminderDuration // ignore: cast_nullable_to_non_nullable
              as ReminderDuration,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
      archivedAt: freezed == archivedAt
          ? _value.archivedAt
          : archivedAt // ignore: cast_nullable_to_non_nullable
              as int?,
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

class _$MedicationImpl extends _Medication {
  const _$MedicationImpl(
      {required this.id,
      required this.profileId,
      required this.name,
      required this.dosage,
      required this.frequency,
      this.instructions,
      this.reminderMessage,
      this.reminderDuration = const ReminderDuration.fixedDays(days: 7),
      this.isCritical = false,
      this.iconName = 'pill',
      this.colorHex = '#4CAF50',
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt,
      this.archivedAt,
      this.syncStatus = 'local',
      this.xpValue = 10})
      : super._();

  @override
  final String id;
  @override
  final String profileId;
  @override
  final String name;
  @override
  final String dosage;
  @override
  final MedicationFrequency frequency;
  @override
  final String? instructions;
  @override
  final String? reminderMessage;
  @override
  @JsonKey()
  final ReminderDuration reminderDuration;
  @override
  @JsonKey()
  final bool isCritical;
  @override
  @JsonKey()
  final String iconName;
  @override
  @JsonKey()
  final String colorHex;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int? archivedAt;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  @JsonKey()
  final int xpValue;

  @override
  String toString() {
    return 'Medication(id: $id, profileId: $profileId, name: $name, dosage: $dosage, frequency: $frequency, instructions: $instructions, reminderMessage: $reminderMessage, reminderDuration: $reminderDuration, isCritical: $isCritical, iconName: $iconName, colorHex: $colorHex, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, archivedAt: $archivedAt, syncStatus: $syncStatus, xpValue: $xpValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.reminderMessage, reminderMessage) ||
                other.reminderMessage == reminderMessage) &&
            (identical(other.reminderDuration, reminderDuration) ||
                other.reminderDuration == reminderDuration) &&
            (identical(other.isCritical, isCritical) ||
                other.isCritical == isCritical) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.xpValue, xpValue) || other.xpValue == xpValue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      profileId,
      name,
      dosage,
      frequency,
      instructions,
      reminderMessage,
      reminderDuration,
      isCritical,
      iconName,
      colorHex,
      isActive,
      createdAt,
      updatedAt,
      archivedAt,
      syncStatus,
      xpValue);

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationImplCopyWith<_$MedicationImpl> get copyWith =>
      __$$MedicationImplCopyWithImpl<_$MedicationImpl>(this, _$identity);
}

abstract class _Medication extends Medication {
  const factory _Medication(
      {required final String id,
      required final String profileId,
      required final String name,
      required final String dosage,
      required final MedicationFrequency frequency,
      final String? instructions,
      final String? reminderMessage,
      final ReminderDuration reminderDuration,
      final bool isCritical,
      final String iconName,
      final String colorHex,
      final bool isActive,
      required final int createdAt,
      required final int updatedAt,
      final int? archivedAt,
      final String syncStatus,
      final int xpValue}) = _$MedicationImpl;
  const _Medication._() : super._();

  @override
  String get id;
  @override
  String get profileId;
  @override
  String get name;
  @override
  String get dosage;
  @override
  MedicationFrequency get frequency;
  @override
  String? get instructions;
  @override
  String? get reminderMessage;
  @override
  ReminderDuration get reminderDuration;
  @override
  bool get isCritical;
  @override
  String get iconName;
  @override
  String get colorHex;
  @override
  bool get isActive;
  @override
  int get createdAt;
  @override
  int get updatedAt;
  @override
  int? get archivedAt;
  @override
  String get syncStatus;
  @override
  int get xpValue;

  /// Create a copy of Medication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationImplCopyWith<_$MedicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
