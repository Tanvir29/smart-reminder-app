/// Bidirectional mapper: Reminder entity <-> ReminderSchema (Drift).
library;

import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart' as db;
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart'
    as entity;
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:uuid/uuid.dart';

/// Maps between Reminder domain entity and ReminderSchema (Drift).
class ReminderMapper {
  ReminderMapper();

  entity.Reminder toEntity(db.ReminderSchema schema) {
    return entity.Reminder(
      id: schema.id,
      profileId: schema.profileId,
      type: schema.type,
      title: schema.title,
      body: schema.body,
      status: ReminderStatus.values.firstWhere(
        (s) => s.name == schema.status,
        orElse: () => ReminderStatus.scheduled,
      ),
      scheduledTime: schema.scheduledTime,
      actualTriggerTime: schema.actualTriggerTime,
      snoozeCount: schema.snoozeCount,
      escalationCount: schema.escalationCount,
      confirmationMode: schema.confirmationMode,
      linkedEntityId: schema.linkedEntityId,
      linkedEntityType: schema.linkedEntityType,
      policy: EscalationPolicy(
        maxSnoozes: schema.maxSnoozes,
        snoozeBaseDelayMinutes: schema.snoozeBaseDelayMinutes,
        responseWindowSeconds: schema.responseWindowSeconds,
        maxEscalations: schema.maxEscalations,
        escalationIntervalSeconds: schema.escalationIntervalSeconds,
        confirmationWindowSeconds: schema.confirmationWindowSeconds,
      ),
      createdAt: schema.createdAt,
      updatedAt: schema.updatedAt,
      completedAt: schema.completedAt,
      cancellationReason: schema.cancellationReason,
      syncStatus: schema.syncStatus,
      xpValue: schema.xpValue,
    );
  }

  db.RemindersCompanion toSchema(entity.Reminder reminder) {
    return db.RemindersCompanion(
      id: Value(reminder.id),
      profileId: Value(reminder.profileId),
      type: Value(reminder.type),
      title: Value(reminder.title),
      body: Value(reminder.body),
      status: Value(reminder.status.name),
      scheduledTime: Value(reminder.scheduledTime),
      actualTriggerTime: Value(reminder.actualTriggerTime),
      snoozeCount: Value(reminder.snoozeCount),
      escalationCount: Value(reminder.escalationCount),
      confirmationMode: Value(reminder.confirmationMode),
      linkedEntityId: Value(reminder.linkedEntityId),
      linkedEntityType: Value(reminder.linkedEntityType),
      maxSnoozes: Value(reminder.policy.maxSnoozes),
      snoozeBaseDelayMinutes: Value(reminder.policy.snoozeBaseDelayMinutes),
      responseWindowSeconds: Value(reminder.policy.responseWindowSeconds),
      maxEscalations: Value(reminder.policy.maxEscalations),
      escalationIntervalSeconds:
          Value(reminder.policy.escalationIntervalSeconds),
      confirmationWindowSeconds:
          Value(reminder.policy.confirmationWindowSeconds),
      createdAt: Value(reminder.createdAt),
      updatedAt: Value(reminder.updatedAt),
      completedAt: Value(reminder.completedAt),
      cancellationReason: Value(reminder.cancellationReason),
      syncStatus: Value(reminder.syncStatus),
      xpValue: Value(reminder.xpValue),
    );
  }

  db.ReminderSchema toSchemaForUpdate(entity.Reminder reminder) {
    return db.ReminderSchema(
      id: reminder.id,
      profileId: reminder.profileId,
      type: reminder.type,
      title: reminder.title,
      body: reminder.body,
      status: reminder.status.name,
      scheduledTime: reminder.scheduledTime,
      actualTriggerTime: reminder.actualTriggerTime,
      snoozeCount: reminder.snoozeCount,
      escalationCount: reminder.escalationCount,
      confirmationMode: reminder.confirmationMode,
      linkedEntityId: reminder.linkedEntityId,
      linkedEntityType: reminder.linkedEntityType,
      maxSnoozes: reminder.policy.maxSnoozes,
      snoozeBaseDelayMinutes: reminder.policy.snoozeBaseDelayMinutes,
      responseWindowSeconds: reminder.policy.responseWindowSeconds,
      maxEscalations: reminder.policy.maxEscalations,
      escalationIntervalSeconds: reminder.policy.escalationIntervalSeconds,
      confirmationWindowSeconds: reminder.policy.confirmationWindowSeconds,
      createdAt: reminder.createdAt,
      updatedAt: reminder.updatedAt,
      completedAt: reminder.completedAt,
      cancellationReason: reminder.cancellationReason,
      syncStatus: reminder.syncStatus,
      xpValue: reminder.xpValue,
    );
  }

  db.ReminderLogsCompanion toLogCompanion({
    required String reminderId,
    required String eventType,
    required int eventTimestamp,
    String? metadata,
    String profileId = 'default',
  }) {
    return db.ReminderLogsCompanion(
      id: Value(const Uuid().v4()),
      profileId: Value(profileId),
      reminderId: Value(reminderId),
      eventType: Value(eventType),
      eventTimestamp: Value(eventTimestamp),
      metadata: Value(metadata),
      createdAt: Value(DateTime.now().millisecondsSinceEpoch),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      syncStatus: const Value('local'),
    );
  }
}
