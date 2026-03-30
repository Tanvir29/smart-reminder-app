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

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockReminderDao mockDao;
  late MockReminderMapper mockMapper;
  late ReminderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeReminderSchema());
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
}
