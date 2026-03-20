import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_snooze.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/escalate_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/log_missed_reminder.dart';
import 'package:smart_reminder_app/core/security/data/secure_storage_impl.dart';
import 'package:smart_reminder_app/core/security/domain/repositories/secure_storage_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Infrastructure providers
// ──────────────────────────────────────────────────────────────────────────────

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final storage = ref.read(secureStorageProvider);
  String? passphrase = await storage.read('db_passphrase');

  if (passphrase == null || passphrase.isEmpty) {
    passphrase = DateTime.now().millisecondsSinceEpoch.toString();
    await storage.write('db_passphrase', passphrase);
  }

  return AppDatabase.openEncrypted(passphrase);
});

final secureStorageProvider = Provider<SecureStorageRepository>((ref) {
  return SecureStorageImpl();
});

final reminderMapperProvider = Provider<ReminderMapper>((ref) {
  return ReminderMapper();
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final databaseAsync = ref.watch(databaseProvider);
  final mapper = ref.watch(reminderMapperProvider);

  return databaseAsync.when(
    data: (db) => ReminderRepositoryImpl(
      dao: db.reminderDao,
      mapper: mapper,
    ),
    loading: () => throw Exception('Database not initialized'),
    error: (e, st) => throw Exception('Database error: $e'),
  );
});

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// ──────────────────────────────────────────────────────────────────────────────
// Use case providers (Phase 2C — The Brain)
// ──────────────────────────────────────────────────────────────────────────────

final scheduleReminderProvider = Provider<ScheduleReminder>((ref) {
  return ScheduleReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
  );
});

final handleSnoozeProvider = Provider<HandleSnooze>((ref) {
  return HandleSnooze(
    repository: ref.watch(reminderRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
  );
});

final confirmReminderProvider = Provider<ConfirmReminder>((ref) {
  return ConfirmReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
  );
});

final escalateReminderProvider = Provider<EscalateReminder>((ref) {
  return EscalateReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
  );
});

final logMissedReminderProvider = Provider<LogMissedReminder>((ref) {
  return LogMissedReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
  );
});
