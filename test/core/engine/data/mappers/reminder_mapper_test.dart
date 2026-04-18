import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/database/app_database.dart' as db;

void main() {
  late ReminderMapper mapper;

  setUp(() {
    mapper = ReminderMapper();
  });

  final now = DateTime.now().millisecondsSinceEpoch;

  db.ReminderSchema createTestSchema({
    String id = 'rem-1',
    String profileId = 'default',
    String type = 'medication',
    String title = 'Morning Meds',
    String? body = 'Take your pills',
    String status = 'scheduled',
    int scheduledTime = 1700000000000,
    int? actualTriggerTime,
    int snoozeCount = 0,
    int escalationCount = 0,
    String confirmationMode = 'swipeToConfirm',
    int groupDoseCount = 1,
    int maxSnoozes = 3,
    int snoozeBaseDelayMinutes = 5,
    int responseWindowSeconds = 300,
    int maxEscalations = 3,
    int escalationIntervalSeconds = 600,
    int confirmationWindowSeconds = 30,
    int? completedAt,
    String? cancellationReason,
  }) {
    return db.ReminderSchema(
      id: id,
      profileId: profileId,
      type: type,
      title: title,
      body: body,
      status: status,
      scheduledTime: scheduledTime,
      actualTriggerTime: actualTriggerTime,
      snoozeCount: snoozeCount,
      escalationCount: escalationCount,
      confirmationMode: confirmationMode,
      groupDoseCount: groupDoseCount,
      maxSnoozes: maxSnoozes,
      snoozeBaseDelayMinutes: snoozeBaseDelayMinutes,
      responseWindowSeconds: responseWindowSeconds,
      maxEscalations: maxEscalations,
      escalationIntervalSeconds: escalationIntervalSeconds,
      confirmationWindowSeconds: confirmationWindowSeconds,
      createdAt: now,
      updatedAt: now,
      completedAt: completedAt,
      cancellationReason: cancellationReason,
      syncStatus: 'local',
      xpValue: 10,
    );
  }

  Reminder createTestEntity({
    String id = 'rem-1',
    String profileId = 'default',
    String type = 'medication',
    String title = 'Morning Meds',
    String? body = 'Take your pills',
    ReminderStatus status = ReminderStatus.scheduled,
    int scheduledTime = 1700000000000,
    int? actualTriggerTime,
    int snoozeCount = 0,
    int escalationCount = 0,
    String confirmationMode = 'swipeToConfirm',
    int groupDoseCount = 1,
    EscalationPolicy? policy,
    int? completedAt,
    String? cancellationReason,
  }) {
    return Reminder(
      id: id,
      profileId: profileId,
      type: type,
      title: title,
      body: body,
      status: status,
      scheduledTime: scheduledTime,
      actualTriggerTime: actualTriggerTime,
      snoozeCount: snoozeCount,
      escalationCount: escalationCount,
      confirmationMode: confirmationMode,
      groupDoseCount: groupDoseCount,
      policy: policy ?? const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
      completedAt: completedAt,
      cancellationReason: cancellationReason,
    );
  }

  group('ReminderMapper.toEntity', () {
    test('maps all scalar fields correctly', () {
      final schema = createTestSchema();

      final entity = mapper.toEntity(schema);

      expect(entity.id, equals('rem-1'));
      expect(entity.profileId, equals('default'));
      expect(entity.type, equals('medication'));
      expect(entity.title, equals('Morning Meds'));
      expect(entity.scheduledTime, equals(1700000000000));
      expect(entity.snoozeCount, equals(0));
      expect(entity.escalationCount, equals(0));
      expect(entity.confirmationMode, equals('swipeToConfirm'));
      expect(entity.groupDoseCount, equals(1));
      expect(entity.syncStatus, equals('local'));
      expect(entity.xpValue, equals(10));
    });

    test('maps nullable fields with values', () {
      final schema = createTestSchema(
        body: 'Custom body',
        actualTriggerTime: 1700000001000,
        completedAt: 1700000002000,
        cancellationReason: 'User cancelled',
      );

      final entity = mapper.toEntity(schema);

      expect(entity.body, equals('Custom body'));
      expect(entity.actualTriggerTime, equals(1700000001000));
      expect(entity.completedAt, equals(1700000002000));
      expect(entity.cancellationReason, equals('User cancelled'));
    });

    test('maps nullable fields as null', () {
      final schema = createTestSchema(
        body: null,
        actualTriggerTime: null,
        completedAt: null,
        cancellationReason: null,
      );

      final entity = mapper.toEntity(schema);

      expect(entity.body, isNull);
      expect(entity.actualTriggerTime, isNull);
      expect(entity.completedAt, isNull);
      expect(entity.cancellationReason, isNull);
    });

    test('deserializes ReminderStatus from string', () {
      for (final status in ReminderStatus.values) {
        final schema = createTestSchema(status: status.name);
        final entity = mapper.toEntity(schema);
        expect(entity.status, equals(status));
      }
    });

    test('defaults to scheduled for unknown status string', () {
      final schema = createTestSchema(status: 'unknown_status');

      final entity = mapper.toEntity(schema);

      expect(entity.status, equals(ReminderStatus.scheduled));
    });

    test('reconstructs EscalationPolicy from 6 denormalized columns', () {
      final schema = createTestSchema(
        maxSnoozes: 2,
        snoozeBaseDelayMinutes: 10,
        responseWindowSeconds: 120,
        maxEscalations: 5,
        escalationIntervalSeconds: 300,
        confirmationWindowSeconds: 60,
      );

      final entity = mapper.toEntity(schema);

      expect(entity.policy.maxSnoozes, equals(2));
      expect(entity.policy.snoozeBaseDelayMinutes, equals(10));
      expect(entity.policy.responseWindowSeconds, equals(120));
      expect(entity.policy.maxEscalations, equals(5));
      expect(entity.policy.escalationIntervalSeconds, equals(300));
      expect(entity.policy.confirmationWindowSeconds, equals(60));
    });
  });

  group('ReminderMapper.toSchemaForUpdate', () {
    test('produces ReminderSchema matching entity fields', () {
      final entity = createTestEntity(
        snoozeCount: 2,
        escalationCount: 1,
        groupDoseCount: 3,
        policy: const EscalationPolicy(maxSnoozes: 2),
        completedAt: 1700000002000,
        cancellationReason: 'Test cancel',
      );

      final schema = mapper.toSchemaForUpdate(entity);

      expect(schema.id, equals(entity.id));
      expect(schema.profileId, equals(entity.profileId));
      expect(schema.type, equals(entity.type));
      expect(schema.title, equals(entity.title));
      expect(schema.body, equals(entity.body));
      expect(schema.status, equals(entity.status.name));
      expect(schema.scheduledTime, equals(entity.scheduledTime));
      expect(schema.snoozeCount, equals(2));
      expect(schema.escalationCount, equals(1));
      expect(schema.groupDoseCount, equals(3));
      expect(schema.maxSnoozes, equals(2));
      expect(schema.completedAt, equals(1700000002000));
      expect(schema.cancellationReason, equals('Test cancel'));
    });

    test('flattens EscalationPolicy into 6 columns', () {
      final entity = createTestEntity(
        policy: const EscalationPolicy(
          maxSnoozes: 4,
          snoozeBaseDelayMinutes: 15,
          responseWindowSeconds: 600,
          maxEscalations: 7,
          escalationIntervalSeconds: 120,
          confirmationWindowSeconds: 45,
        ),
      );

      final schema = mapper.toSchemaForUpdate(entity);

      expect(schema.maxSnoozes, equals(4));
      expect(schema.snoozeBaseDelayMinutes, equals(15));
      expect(schema.responseWindowSeconds, equals(600));
      expect(schema.maxEscalations, equals(7));
      expect(schema.escalationIntervalSeconds, equals(120));
      expect(schema.confirmationWindowSeconds, equals(45));
    });
  });

  group('ReminderMapper round-trip', () {
    test('entity → toSchemaForUpdate → toEntity preserves all fields', () {
      final original = createTestEntity(
        snoozeCount: 3,
        escalationCount: 2,
        groupDoseCount: 5,
        body: 'Test body',
        actualTriggerTime: 1700000005000,
        policy: const EscalationPolicy(
          maxSnoozes: 2,
          snoozeBaseDelayMinutes: 10,
        ),
        status: ReminderStatus.escalating,
      );

      final schema = mapper.toSchemaForUpdate(original);
      final roundTripped = mapper.toEntity(schema);

      expect(roundTripped.id, equals(original.id));
      expect(roundTripped.profileId, equals(original.profileId));
      expect(roundTripped.type, equals(original.type));
      expect(roundTripped.title, equals(original.title));
      expect(roundTripped.body, equals(original.body));
      expect(roundTripped.status, equals(original.status));
      expect(roundTripped.scheduledTime, equals(original.scheduledTime));
      expect(roundTripped.snoozeCount, equals(original.snoozeCount));
      expect(roundTripped.escalationCount, equals(original.escalationCount));
      expect(roundTripped.groupDoseCount, equals(original.groupDoseCount));
      expect(roundTripped.policy.maxSnoozes, equals(2));
      expect(roundTripped.policy.snoozeBaseDelayMinutes, equals(10));
    });
  });

  group('ReminderMapper.toLogCompanion', () {
    test('creates log entry with required fields', () {
      final companion = mapper.toLogCompanion(
        reminderId: 'rem-1',
        eventType: 'triggered',
        eventTimestamp: now,
        metadata: 'Test metadata',
      );

      expect(companion.reminderId.value, equals('rem-1'));
      expect(companion.eventType.value, equals('triggered'));
      expect(companion.eventTimestamp.value, equals(now));
      expect(companion.metadata.value, equals('Test metadata'));
    });

    test('uses default profileId', () {
      final companion = mapper.toLogCompanion(
        reminderId: 'rem-1',
        eventType: 'snoozed',
        eventTimestamp: now,
      );

      expect(companion.profileId.value, equals('default'));
    });

    test('generates non-empty UUID for id', () {
      final companion = mapper.toLogCompanion(
        reminderId: 'rem-1',
        eventType: 'confirmed',
        eventTimestamp: now,
      );

      expect(companion.id.value, isNotEmpty);
    });
  });
}
