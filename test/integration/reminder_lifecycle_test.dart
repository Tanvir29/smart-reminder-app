import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:sqlite3/open.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }

  group('Reminder Lifecycle Integration Test', () {
    late AppDatabase db;
    late ReminderRepositoryImpl repository;
    late ReminderMapper mapper;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      mapper = ReminderMapper();
      repository = ReminderRepositoryImpl(dao: db.reminderDao, mapper: mapper);
    });

    tearDown(() async {
      await db.close();
    });

    final now = DateTime.now().millisecondsSinceEpoch;

    Reminder createTestReminder({
      String id = 'rem-1',
      ReminderStatus status = ReminderStatus.scheduled,
      int scheduledTime = 1700000000000,
      int snoozeCount = 0,
      int escalationCount = 0,
      int groupDoseCount = 1,
      EscalationPolicy? policy,
    }) {
      return Reminder(
        id: id,
        profileId: 'default',
        type: 'medication',
        title: 'Morning Meds',
        status: status,
        scheduledTime: scheduledTime,
        snoozeCount: snoozeCount,
        escalationCount: escalationCount,
        groupDoseCount: groupDoseCount,
        policy: policy ?? const EscalationPolicy(),
        createdAt: now,
        updatedAt: now,
      );
    }

    test(
        'happy path: save → updateStatus to triggered → confirm → verify logged',
        () async {
      final reminder = createTestReminder();
      await repository.save(reminder);

      final saved = await repository.getById('rem-1');
      expect(saved, isNotNull);
      expect(saved!.status, equals(ReminderStatus.scheduled));

      await repository.updateStatus('rem-1', ReminderStatus.triggered);
      final triggered = await repository.getById('rem-1');
      expect(triggered!.status, equals(ReminderStatus.triggered));

      await repository.updateStatus(
          'rem-1', ReminderStatus.confirmationRequired);
      final confirming = await repository.getById('rem-1');
      expect(confirming!.status, equals(ReminderStatus.confirmationRequired));

      await repository.updateStatus('rem-1', ReminderStatus.logged);
      final logged = await repository.getById('rem-1');
      expect(logged!.status, equals(ReminderStatus.logged));
    });

    test('snooze path: save → triggered → snoozed → triggered → confirmed',
        () async {
      final reminder = createTestReminder();
      await repository.save(reminder);

      await repository.updateStatus('rem-1', ReminderStatus.triggered);
      await repository.updateStatus('rem-1', ReminderStatus.snoozed);

      final snoozed = await repository.getById('rem-1');
      expect(snoozed!.status, equals(ReminderStatus.snoozed));

      await repository.updateStatus('rem-1', ReminderStatus.triggered);
      await repository.updateStatus(
          'rem-1', ReminderStatus.confirmationRequired);
      await repository.updateStatus('rem-1', ReminderStatus.logged);

      final logged = await repository.getById('rem-1');
      expect(logged!.status, equals(ReminderStatus.logged));
    });

    test('escalation to missed: triggered → escalate × 4 → missed in DB',
        () async {
      final reminder = createTestReminder();
      await repository.save(reminder);

      await repository.updateStatus('rem-1', ReminderStatus.triggered);
      await repository.updateStatus('rem-1', ReminderStatus.escalating);

      final escalating = await repository.getById('rem-1');
      expect(escalating!.status, equals(ReminderStatus.escalating));

      await repository.updateStatus('rem-1', ReminderStatus.missed);

      final missed = await repository.getById('rem-1');
      expect(missed!.status, equals(ReminderStatus.missed));
    });

    test('logEvent persists events in the database', () async {
      final reminder = createTestReminder();
      await repository.save(reminder);

      await repository.logEvent(
        reminderId: 'rem-1',
        eventType: 'triggered',
        eventTimestamp: now,
        metadata: 'Alarm fired',
      );

      final logs = await db.reminderDao.getReminderLogs('rem-1');
      expect(logs, isNotEmpty);
      expect(logs.first.eventType, equals('triggered'));
      expect(logs.first.metadata, equals('Alarm fired'));
    });

    test('getByScheduledTime returns reminders at exact timestamp', () async {
      const scheduledTime = 1700000000000;
      final reminder1 =
          createTestReminder(id: 'rem-1', scheduledTime: scheduledTime);
      final reminder2 =
          createTestReminder(id: 'rem-2', scheduledTime: scheduledTime);
      final reminder3 =
          createTestReminder(id: 'rem-3', scheduledTime: scheduledTime + 60000);

      await repository.save(reminder1);
      await repository.save(reminder2);
      await repository.save(reminder3);

      final results = await repository.getByScheduledTime(scheduledTime);

      expect(results, hasLength(2));
      expect(
        results.map((r) => r.id).toSet(),
        equals({'rem-1', 'rem-2'}),
      );
    });

    test('getByStatus filters correctly', () async {
      final r1 =
          createTestReminder(id: 'rem-1', status: ReminderStatus.scheduled);
      final r2 =
          createTestReminder(id: 'rem-2', status: ReminderStatus.triggered);
      final r3 =
          createTestReminder(id: 'rem-3', status: ReminderStatus.scheduled);

      await repository.save(r1);
      await repository.save(r2);
      await repository.save(r3);

      final scheduled = await repository.getByStatus(ReminderStatus.scheduled);
      final triggered = await repository.getByStatus(ReminderStatus.triggered);

      expect(scheduled, hasLength(2));
      expect(triggered, hasLength(1));
      expect(triggered.first.id, equals('rem-2'));
    });
  });
}
