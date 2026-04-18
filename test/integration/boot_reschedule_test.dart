import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/alarm_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_reminder.dart';
import 'package:sqlite3/open.dart';

class MockAlarmPort extends Mock implements AlarmPort {}

class FakeReminder extends Fake implements Reminder {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  }

  group('Boot Reschedule Integration Test', () {
    late AppDatabase db;
    late ReminderRepositoryImpl repository;
    late ReminderMapper mapper;
    late MockAlarmPort mockAlarmPort;

    final now = DateTime.now().millisecondsSinceEpoch;

    setUp(() async {
      registerFallbackValue(FakeReminder());
      registerFallbackValue(DateTime(2024));

      db = AppDatabase(NativeDatabase.memory());
      mapper = ReminderMapper();
      repository = ReminderRepositoryImpl(dao: db.reminderDao, mapper: mapper);
      mockAlarmPort = MockAlarmPort();

      when(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).thenAnswer((_) async => true);
    });

    tearDown(() async {
      await db.close();
    });

    Reminder createTestReminder({
      String id = 'rem-1',
      ReminderStatus status = ReminderStatus.scheduled,
      int scheduledTime = 1700000000000,
    }) {
      return Reminder(
        id: id,
        profileId: 'default',
        type: 'medication',
        title: 'Morning Meds',
        status: status,
        scheduledTime: scheduledTime,
        policy: const EscalationPolicy(),
        createdAt: now,
        updatedAt: now,
      );
    }

    test('recovers all scheduled reminders after simulated boot', () async {
      final r1 =
          createTestReminder(id: 'rem-1', status: ReminderStatus.scheduled);
      final r2 =
          createTestReminder(id: 'rem-2', status: ReminderStatus.scheduled);
      final r3 =
          createTestReminder(id: 'rem-3', status: ReminderStatus.triggered);
      final r4 = createTestReminder(id: 'rem-4', status: ReminderStatus.logged);

      await repository.save(r1);
      await repository.save(r2);
      await repository.save(r3);
      await repository.save(r4);

      final recovered = await repository.getByStatus(ReminderStatus.scheduled);

      expect(recovered, hasLength(2));
      expect(
        recovered.map((r) => r.id).toSet(),
        equals({'rem-1', 'rem-2'}),
      );
      for (final r in recovered) {
        expect(r.scheduledTime, equals(1700000000000));
      }
    });

    test('recovers snoozed reminders with correct scheduled time', () async {
      final snoozeTime = now + 600000;
      final r1 = createTestReminder(
        id: 'rem-1',
        status: ReminderStatus.snoozed,
        scheduledTime: snoozeTime,
      );
      final r2 = createTestReminder(
        id: 'rem-2',
        status: ReminderStatus.missed,
        scheduledTime: snoozeTime,
      );

      await repository.save(r1);
      await repository.save(r2);

      final recovered = await repository.getByStatus(ReminderStatus.snoozed);

      expect(recovered, hasLength(1));
      expect(recovered.first.id, equals('rem-1'));
      expect(recovered.first.scheduledTime, equals(snoozeTime));
    });

    test('re-registers alarms for all scheduled and snoozed reminders',
        () async {
      final scheduleTime = now + 3600000;
      final r1 = createTestReminder(
        id: 'rem-1',
        status: ReminderStatus.scheduled,
        scheduledTime: scheduleTime,
      );
      final r2 = createTestReminder(
        id: 'rem-2',
        status: ReminderStatus.snoozed,
        scheduledTime: scheduleTime + 600000,
      );
      final r3 = createTestReminder(
        id: 'rem-3',
        status: ReminderStatus.logged,
        scheduledTime: scheduleTime,
      );

      await repository.save(r1);
      await repository.save(r2);
      await repository.save(r3);

      final scheduled = await repository.getByStatus(ReminderStatus.scheduled);
      final snoozed = await repository.getByStatus(ReminderStatus.snoozed);
      final toReschedule = [...scheduled, ...snoozed];

      expect(toReschedule, hasLength(2));

      final scheduleUseCase = ScheduleReminder(
        repository: repository,
        alarmPort: mockAlarmPort,
      );

      for (final reminder in toReschedule) {
        await scheduleUseCase.call(reminder);
      }

      verify(() => mockAlarmPort.setAlarm(
            id: any(named: 'id'),
            dateTime: any(named: 'dateTime'),
            notificationTitle: any(named: 'notificationTitle'),
            notificationBody: any(named: 'notificationBody'),
          )).called(2);
    });
  });
}
