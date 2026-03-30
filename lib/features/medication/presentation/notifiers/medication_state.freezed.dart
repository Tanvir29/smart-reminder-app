// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MedicationState {
  List<Medication> get medications => throw _privateConstructorUsedError;
  List<DoseRecord> get todaysDoses => throw _privateConstructorUsedError;
  DoseRecord? get lastRecordedDose => throw _privateConstructorUsedError;

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationStateCopyWith<MedicationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationStateCopyWith<$Res> {
  factory $MedicationStateCopyWith(
          MedicationState value, $Res Function(MedicationState) then) =
      _$MedicationStateCopyWithImpl<$Res, MedicationState>;
  @useResult
  $Res call(
      {List<Medication> medications,
      List<DoseRecord> todaysDoses,
      DoseRecord? lastRecordedDose});

  $DoseRecordCopyWith<$Res>? get lastRecordedDose;
}

/// @nodoc
class _$MedicationStateCopyWithImpl<$Res, $Val extends MedicationState>
    implements $MedicationStateCopyWith<$Res> {
  _$MedicationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medications = null,
    Object? todaysDoses = null,
    Object? lastRecordedDose = freezed,
  }) {
    return _then(_value.copyWith(
      medications: null == medications
          ? _value.medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<Medication>,
      todaysDoses: null == todaysDoses
          ? _value.todaysDoses
          : todaysDoses // ignore: cast_nullable_to_non_nullable
              as List<DoseRecord>,
      lastRecordedDose: freezed == lastRecordedDose
          ? _value.lastRecordedDose
          : lastRecordedDose // ignore: cast_nullable_to_non_nullable
              as DoseRecord?,
    ) as $Val);
  }

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseRecordCopyWith<$Res>? get lastRecordedDose {
    if (_value.lastRecordedDose == null) {
      return null;
    }

    return $DoseRecordCopyWith<$Res>(_value.lastRecordedDose!, (value) {
      return _then(_value.copyWith(lastRecordedDose: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicationStateImplCopyWith<$Res>
    implements $MedicationStateCopyWith<$Res> {
  factory _$$MedicationStateImplCopyWith(_$MedicationStateImpl value,
          $Res Function(_$MedicationStateImpl) then) =
      __$$MedicationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Medication> medications,
      List<DoseRecord> todaysDoses,
      DoseRecord? lastRecordedDose});

  @override
  $DoseRecordCopyWith<$Res>? get lastRecordedDose;
}

/// @nodoc
class __$$MedicationStateImplCopyWithImpl<$Res>
    extends _$MedicationStateCopyWithImpl<$Res, _$MedicationStateImpl>
    implements _$$MedicationStateImplCopyWith<$Res> {
  __$$MedicationStateImplCopyWithImpl(
      _$MedicationStateImpl _value, $Res Function(_$MedicationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medications = null,
    Object? todaysDoses = null,
    Object? lastRecordedDose = freezed,
  }) {
    return _then(_$MedicationStateImpl(
      medications: null == medications
          ? _value._medications
          : medications // ignore: cast_nullable_to_non_nullable
              as List<Medication>,
      todaysDoses: null == todaysDoses
          ? _value._todaysDoses
          : todaysDoses // ignore: cast_nullable_to_non_nullable
              as List<DoseRecord>,
      lastRecordedDose: freezed == lastRecordedDose
          ? _value.lastRecordedDose
          : lastRecordedDose // ignore: cast_nullable_to_non_nullable
              as DoseRecord?,
    ));
  }
}

/// @nodoc

class _$MedicationStateImpl extends _MedicationState {
  const _$MedicationStateImpl(
      {final List<Medication> medications = const [],
      final List<DoseRecord> todaysDoses = const [],
      this.lastRecordedDose})
      : _medications = medications,
        _todaysDoses = todaysDoses,
        super._();

  final List<Medication> _medications;
  @override
  @JsonKey()
  List<Medication> get medications {
    if (_medications is EqualUnmodifiableListView) return _medications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medications);
  }

  final List<DoseRecord> _todaysDoses;
  @override
  @JsonKey()
  List<DoseRecord> get todaysDoses {
    if (_todaysDoses is EqualUnmodifiableListView) return _todaysDoses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todaysDoses);
  }

  @override
  final DoseRecord? lastRecordedDose;

  @override
  String toString() {
    return 'MedicationState(medications: $medications, todaysDoses: $todaysDoses, lastRecordedDose: $lastRecordedDose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._medications, _medications) &&
            const DeepCollectionEquality()
                .equals(other._todaysDoses, _todaysDoses) &&
            (identical(other.lastRecordedDose, lastRecordedDose) ||
                other.lastRecordedDose == lastRecordedDose));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_medications),
      const DeepCollectionEquality().hash(_todaysDoses),
      lastRecordedDose);

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationStateImplCopyWith<_$MedicationStateImpl> get copyWith =>
      __$$MedicationStateImplCopyWithImpl<_$MedicationStateImpl>(
          this, _$identity);
}

abstract class _MedicationState extends MedicationState {
  const factory _MedicationState(
      {final List<Medication> medications,
      final List<DoseRecord> todaysDoses,
      final DoseRecord? lastRecordedDose}) = _$MedicationStateImpl;
  const _MedicationState._() : super._();

  @override
  List<Medication> get medications;
  @override
  List<DoseRecord> get todaysDoses;
  @override
  DoseRecord? get lastRecordedDose;

  /// Create a copy of MedicationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationStateImplCopyWith<_$MedicationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
