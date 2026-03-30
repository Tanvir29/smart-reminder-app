// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyFrequencyImpl _$$DailyFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$DailyFrequencyImpl(
      timesOfDay: (json['timesOfDay'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DailyFrequencyImplToJson(
        _$DailyFrequencyImpl instance) =>
    <String, dynamic>{
      'timesOfDay': instance.timesOfDay,
      'runtimeType': instance.$type,
    };

_$WeeklyFrequencyImpl _$$WeeklyFrequencyImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyFrequencyImpl(
      timesOfDay: (json['timesOfDay'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      weekDays: (json['weekDays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$WeeklyFrequencyImplToJson(
        _$WeeklyFrequencyImpl instance) =>
    <String, dynamic>{
      'timesOfDay': instance.timesOfDay,
      'weekDays': instance.weekDays,
      'runtimeType': instance.$type,
    };

_$IntervalFrequencyImpl _$$IntervalFrequencyImplFromJson(
        Map<String, dynamic> json) =>
    _$IntervalFrequencyImpl(
      intervalHours: (json['intervalHours'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IntervalFrequencyImplToJson(
        _$IntervalFrequencyImpl instance) =>
    <String, dynamic>{
      'intervalHours': instance.intervalHours,
      'runtimeType': instance.$type,
    };

_$AsNeededFrequencyImpl _$$AsNeededFrequencyImplFromJson(
        Map<String, dynamic> json) =>
    _$AsNeededFrequencyImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AsNeededFrequencyImplToJson(
        _$AsNeededFrequencyImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$FixedDaysDurationImpl _$$FixedDaysDurationImplFromJson(
        Map<String, dynamic> json) =>
    _$FixedDaysDurationImpl(
      days: (json['days'] as num?)?.toInt() ?? 7,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FixedDaysDurationImplToJson(
        _$FixedDaysDurationImpl instance) =>
    <String, dynamic>{
      'days': instance.days,
      'runtimeType': instance.$type,
    };

_$OneMonthDurationImpl _$$OneMonthDurationImplFromJson(
        Map<String, dynamic> json) =>
    _$OneMonthDurationImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$OneMonthDurationImplToJson(
        _$OneMonthDurationImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$ContinuousDurationImpl _$$ContinuousDurationImplFromJson(
        Map<String, dynamic> json) =>
    _$ContinuousDurationImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ContinuousDurationImplToJson(
        _$ContinuousDurationImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$CustomDurationImpl _$$CustomDurationImplFromJson(Map<String, dynamic> json) =>
    _$CustomDurationImpl(
      endTime: (json['endTime'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CustomDurationImplToJson(
        _$CustomDurationImpl instance) =>
    <String, dynamic>{
      'endTime': instance.endTime,
      'runtimeType': instance.$type,
    };
