import 'package:drift/drift.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/database/tables/reminder_tables.dart';

part 'reminder_dao.g.dart';

@DriftAccessor(tables: [Reminders, ReminderLogs])
class ReminderDao extends DatabaseAccessor<AppDatabase>
    with _$ReminderDaoMixin {
  ReminderDao(super.db);

  Future<List<ReminderSchema>> getAllReminders() => db.select(reminders).get();

  Future<ReminderSchema?> getReminderById(String id) =>
      (db.select(reminders)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<List<ReminderSchema>> getRemindersByStatus(String status) =>
      (db.select(reminders)..where((r) => r.status.equals(status))).get();

  Future<List<ReminderSchema>> getRemindersByProfile(String profileId) =>
      (db.select(reminders)..where((r) => r.profileId.equals(profileId))).get();

  Future<List<ReminderSchema>> getScheduledReminders() =>
      (db.select(reminders)..where((r) => r.status.equals('scheduled'))).get();

  Future<List<ReminderSchema>> getScheduledRemindersBefore(DateTime time) =>
      (db.select(reminders)
            ..where((r) => r.status.equals('scheduled'))
            ..where(
              (r) => r.scheduledTime.isSmallerOrEqualValue(
                time.millisecondsSinceEpoch,
              ),
            ))
          .get();

  Future<List<ReminderSchema>> getRemindersByScheduledTime(int scheduledTime) =>
      (db.select(reminders)
            ..where((r) => r.scheduledTime.equals(scheduledTime)))
          .get();

  Future<List<ReminderSchema>> getUpcomingScheduledReminders(
          {int limit = 10}) =>
      (db.select(reminders)
            ..where((r) => r.status.equals('scheduled'))
            ..orderBy([(r) => OrderingTerm.asc(r.scheduledTime)])
            ..limit(limit))
          .get();

  Future<void> insertReminder(RemindersCompanion reminder) =>
      db.into(reminders).insert(reminder);

  Future<void> upsertReminder(RemindersCompanion reminder) =>
      db.into(reminders).insertOnConflictUpdate(reminder);

  Future<void> updateReminder(ReminderSchema reminder) =>
      db.update(reminders).replace(reminder);

  Future<void> deleteReminder(String id) =>
      (db.delete(reminders)..where((r) => r.id.equals(id))).go();

  Future<void> logReminderEvent(ReminderLogsCompanion log) =>
      db.into(reminderLogs).insert(log);

  Future<List<ReminderLog>> getReminderLogs(String reminderId) =>
      (db.select(reminderLogs)
            ..where((l) => l.reminderId.equals(reminderId))
            ..orderBy([(l) => OrderingTerm.desc(l.eventTimestamp)]))
          .get();

  Future<List<ReminderSchema>> getRemindersByStatuses(List<String> statuses) =>
      (db.select(reminders)..where((r) => r.status.isIn(statuses))).get();
}
