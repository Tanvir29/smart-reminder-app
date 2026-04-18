import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/daos/reminder_dao.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/escalation_policy.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockReminderDao extends Mock implements ReminderDao {}

class MockReminderMapper extends Mock implements ReminderMapper {}

// ─── Fakes ───────────────────────────────────────────────────────────────────

class FakeReminderSchema extends Fake implements ReminderSchema {}

class FakeRemindersCompanion extends Fake implements RemindersCompanion {}

class FakeReminderLogsCompanion extends Fake implements ReminderLogsCompanion {}

class FakeReminder extends Fake implements Reminder {}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderDao mockDao;
  late MockReminderMapper mockMapper;
  late ReminderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeReminderSchema());
    registerFallbackValue(FakeRemindersCompanion());
    registerFallbackValue(FakeReminderLogsCompanion());
    registerFallbackValue(FakeReminder());
  });

  setUp(() {
    mockDao = MockReminderDao();
    mockMapper = MockReminderMapper();
    repository = ReminderRepositoryImpl(dao: mockDao, mapper: mockMapper);
  });

  /// Helper: creates a test [Reminder] entity.
  Reminder createTestReminder({
    String id = 'rem-1',
    int scheduledTime = 1700000000000,
    int groupDoseCount = 1,
  }) {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return Reminder(
      id: id,
      profileId: 'default',
      type: 'medication',
      title: 'Morning Medications',
      status: ReminderStatus.scheduled,
      scheduledTime: scheduledTime,
      groupDoseCount: groupDoseCount,
      policy: const EscalationPolicy(),
      createdAt: now,
      updatedAt: now,
    );
  }

  group('getByScheduledTime', () {
    test('delegates to DAO.getRemindersByScheduledTime with correct argument',
        () async {
      const scheduledTime = 1700000000000;
      when(() => mockDao.getRemindersByScheduledTime(scheduledTime))
          .thenAnswer((_) async => []);

      await repository.getByScheduledTime(scheduledTime);

      verify(() => mockDao.getRemindersByScheduledTime(scheduledTime))
          .called(1);
    });

    test('returns empty list when no reminders exist at that time', () async {
      const scheduledTime = 1700000000000;
      when(() => mockDao.getRemindersByScheduledTime(scheduledTime))
          .thenAnswer((_) async => []);

      final result = await repository.getByScheduledTime(scheduledTime);

      expect(result, isEmpty);
    });

    test('maps each DAO schema through mapper.toEntity', () async {
      const scheduledTime = 1700000000000;
      final fakeSchema1 = FakeReminderSchema();
      final fakeSchema2 = FakeReminderSchema();
      final expectedEntity1 = createTestReminder(id: 'rem-1');
      final expectedEntity2 = createTestReminder(id: 'rem-2');

      when(() => mockDao.getRemindersByScheduledTime(scheduledTime))
          .thenAnswer((_) async => [fakeSchema1, fakeSchema2]);
      when(() => mockMapper.toEntity(fakeSchema1)).thenReturn(expectedEntity1);
      when(() => mockMapper.toEntity(fakeSchema2)).thenReturn(expectedEntity2);

      final result = await repository.getByScheduledTime(scheduledTime);

      expect(result, hasLength(2));
      expect(result[0].id, equals('rem-1'));
      expect(result[1].id, equals('rem-2'));
      verify(() => mockMapper.toEntity(fakeSchema1)).called(1);
      verify(() => mockMapper.toEntity(fakeSchema2)).called(1);
    });

    test('preserves groupDoseCount from mapped entities', () async {
      const scheduledTime = 1700000000000;
      final fakeSchema = FakeReminderSchema();
      final entity = createTestReminder(id: 'rem-1', groupDoseCount: 3);

      when(() => mockDao.getRemindersByScheduledTime(scheduledTime))
          .thenAnswer((_) async => [fakeSchema]);
      when(() => mockMapper.toEntity(fakeSchema)).thenReturn(entity);

      final result = await repository.getByScheduledTime(scheduledTime);

      expect(result.single.groupDoseCount, equals(3));
    });
  });

  group('save', () {
    test('maps entity via toSchema before delegating to DAO', () async {
      final entity = createTestReminder();
      final fakeCompanion = FakeRemindersCompanion();

      when(() => mockMapper.toSchema(entity)).thenReturn(fakeCompanion);
      when(() => mockDao.upsertReminder(any())).thenAnswer((_) async {});

      await repository.save(entity);

      verify(() => mockMapper.toSchema(entity)).called(1);
      verify(() => mockDao.upsertReminder(any())).called(1);
    });
  });

  group('getById', () {
    test('returns null for non-existent reminder', () async {
      when(() => mockDao.getReminderById('missing'))
          .thenAnswer((_) async => null);

      final result = await repository.getById('missing');

      expect(result, isNull);
    });

    test('returns mapped entity for existing reminder', () async {
      final fakeSchema = FakeReminderSchema();
      final expected = createTestReminder(id: 'rem-1');

      when(() => mockDao.getReminderById('rem-1'))
          .thenAnswer((_) async => fakeSchema);
      when(() => mockMapper.toEntity(fakeSchema)).thenReturn(expected);

      final result = await repository.getById('rem-1');

      expect(result, isNotNull);
      expect(result!.id, equals('rem-1'));
    });
  });

  group('getByStatus', () {
    test('delegates to DAO and maps results', () async {
      final fakeSchema = FakeReminderSchema();
      final entity = createTestReminder(id: 'rem-1');

      when(() => mockDao.getRemindersByStatus('scheduled'))
          .thenAnswer((_) async => [fakeSchema]);
      when(() => mockMapper.toEntity(fakeSchema)).thenReturn(entity);

      final result = await repository.getByStatus(ReminderStatus.scheduled);

      verify(() => mockDao.getRemindersByStatus('scheduled')).called(1);
      expect(result, hasLength(1));
    });
  });

  group('updateStatus', () {
    test('delegates to DAO with updated status', () async {
      final fakeSchema = FakeReminderSchema();
      final entity = createTestReminder(id: 'rem-1');

      when(() => mockDao.getReminderById('rem-1'))
          .thenAnswer((_) async => fakeSchema);
      when(() => mockMapper.toEntity(fakeSchema)).thenReturn(entity);
      when(() => mockMapper.toSchemaForUpdate(any())).thenReturn(fakeSchema);
      when(() => mockDao.updateReminder(any())).thenAnswer((_) async {});

      await repository.updateStatus('rem-1', ReminderStatus.triggered);

      verify(() => mockDao.updateReminder(any())).called(1);
    });

    test('does nothing for non-existent reminder', () async {
      when(() => mockDao.getReminderById('missing'))
          .thenAnswer((_) async => null);

      await repository.updateStatus('missing', ReminderStatus.triggered);

      verifyNever(() => mockDao.updateReminder(any()));
    });
  });

  group('logEvent', () {
    test('creates log companion via mapper and delegates to DAO', () async {
      final fakeLog = FakeReminderLogsCompanion();
      when(() => mockMapper.toLogCompanion(
            reminderId: any(named: 'reminderId'),
            eventType: any(named: 'eventType'),
            eventTimestamp: any(named: 'eventTimestamp'),
            metadata: any(named: 'metadata'),
          )).thenReturn(fakeLog);
      when(() => mockDao.logReminderEvent(any())).thenAnswer((_) async {});

      await repository.logEvent(
        reminderId: 'rem-1',
        eventType: 'triggered',
        eventTimestamp: 1700000000000,
        metadata: 'test',
      );

      verify(() => mockMapper.toLogCompanion(
            reminderId: 'rem-1',
            eventType: 'triggered',
            eventTimestamp: 1700000000000,
            metadata: 'test',
          )).called(1);
      verify(() => mockDao.logReminderEvent(any())).called(1);
    });
  });
}
