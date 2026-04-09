/// Medication domain entity with MedicationFrequency union type.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

/// Type-safe medication frequency — a Freezed union type.
/// Stored as a JSON string in the database.
@freezed
class MedicationFrequency with _$MedicationFrequency {
  /// Medication taken daily at specific times.
  const factory MedicationFrequency.daily({
    required List<int> timesOfDay, // minutes from midnight
  }) = DailyFrequency;

  /// Medication taken on specific days of the week at specific times.
  const factory MedicationFrequency.weekly({
    required List<int> timesOfDay, // minutes from midnight
    required List<int> weekDays, // 1=Monday .. 7=Sunday (ISO 8601)
  }) = WeeklyFrequency;

  /// Medication taken at a fixed hour interval.
  const factory MedicationFrequency.interval({required int intervalHours}) =
      IntervalFrequency;

  /// Medication taken at a specific scheduled time (one-time reminder).
  const factory MedicationFrequency.oneTime({
    required int scheduledTimeMinutes, // minutes from midnight
  }) = OneTimeFrequency;

  factory MedicationFrequency.fromJson(Map<String, dynamic> json) =>
      _$MedicationFrequencyFromJson(json);
}

/// Type-safe reminder duration — a Freezed union type.
/// Stored as a JSON string in the database.
@freezed
class ReminderDuration with _$ReminderDuration {
  /// Fixed duration in days (default: 7 days).
  const factory ReminderDuration.fixedDays({@Default(7) int days}) =
      FixedDaysDuration;

  /// One month duration (30 days).
  const factory ReminderDuration.oneMonth() = OneMonthDuration;

  /// Continuous reminders until manually turned off.
  const factory ReminderDuration.continuous() = ContinuousDuration;

  /// Custom end date/time (Unix milliseconds).
  const factory ReminderDuration.custom({required int endTime}) =
      CustomDuration;

  factory ReminderDuration.fromJson(Map<String, dynamic> json) =>
      _$ReminderDurationFromJson(json);
}

/// Immutable medication entity. All timestamps are Unix milliseconds.
@freezed
class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String profileId,
    required String name,
    required String dosage,
    required MedicationFrequency frequency,
    String? instructions,
    String? reminderMessage,
    @Default(ReminderDuration.fixedDays(days: 7))
    ReminderDuration reminderDuration,
    @Default(false) bool isCritical,
    @Default('pill') String iconName,
    @Default('#4CAF50') String colorHex,
    @Default(true) bool isActive,
    required int createdAt,
    required int updatedAt,
    int? archivedAt,
    @Default('local') String syncStatus,
    @Default(10) int xpValue,
  }) = _Medication;

  const Medication._();
}
