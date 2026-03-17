/// Reminder domain entity — immutable value object representing a scheduled reminder.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

part 'reminder.freezed.dart';

/// Immutable reminder entity. Status transitions validated in-entity.
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String profileId,
    required String type,
    required String title,
    String? body,
    required ReminderStatus status,
    required int scheduledTime,
    int? actualTriggerTime,
    @Default(0) int snoozeCount,
    @Default(0) int escalationCount,
    @Default('swipeToConfirm') String confirmationMode,
    String? linkedEntityId,
    String? linkedEntityType,
    required EscalationPolicy policy,
    required int createdAt,
    required int updatedAt,
    int? completedAt,
    String? cancellationReason,
    @Default('local') String syncStatus,
    @Default(10) int xpValue,
  }) = _Reminder;

  const Reminder._();
}
