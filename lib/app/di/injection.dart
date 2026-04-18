import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/dose_query_port.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/schedule_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_snooze.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/confirm_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/finalize_confirmation.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/escalate_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/log_missed_reminder.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_alarm_fired.dart';
import 'package:smart_reminder_app/core/engine/domain/usecases/handle_escalation_check.dart';
import 'package:smart_reminder_app/core/security/data/secure_storage_impl.dart';
import 'package:smart_reminder_app/core/security/domain/repositories/secure_storage_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';
import 'package:smart_reminder_app/core/platform/voice_service.dart';
import 'package:smart_reminder_app/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:smart_reminder_app/features/medication/data/mappers/medication_mapper.dart';
import 'package:smart_reminder_app/features/medication/domain/repositories/medication_repository.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/add_medication.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/alarm_scheduler.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/reminder_generator.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/record_dose.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/undo_dose.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_medication_schedule.dart';
import 'package:smart_reminder_app/features/medication/domain/usecases/get_adherence_stats.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Infrastructure providers
// ──────────────────────────────────────────────────────────────────────────────

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final storage = ref.read(secureStorageProvider);
  String? passphrase = await storage.read('db_passphrase');

  if (passphrase == null || passphrase.isEmpty) {
    // Per spec §6.2: use Random.secure() for cryptographic passphrase
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    passphrase = base64Url.encode(bytes);
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

final voiceServiceProvider = Provider<VoiceService>((ref) {
  return VoiceService();
});

// ──────────────────────────────────────────────────────────────────────────────
// Use case providers (Phase 2C — The Brain)
// ──────────────────────────────────────────────────────────────────────────────

final scheduleReminderProvider = Provider<ScheduleReminder>((ref) {
  return ScheduleReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final handleSnoozeProvider = Provider<HandleSnooze>((ref) {
  return HandleSnooze(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final confirmReminderProvider = Provider<ConfirmReminder>((ref) {
  return ConfirmReminder(
    repository: ref.watch(reminderRepositoryProvider),
  );
});

final finalizeConfirmationProvider = Provider<FinalizeConfirmation>((ref) {
  return FinalizeConfirmation(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final escalateReminderProvider = Provider<EscalateReminder>((ref) {
  return EscalateReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final logMissedReminderProvider = Provider<LogMissedReminder>((ref) {
  return LogMissedReminder(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final handleAlarmFiredProvider = Provider<HandleAlarmFired>((ref) {
  return HandleAlarmFired(
    reminderRepository: ref.watch(reminderRepositoryProvider),
    doseQueryPort: ref.watch(doseQueryPortProvider),
    notificationPort: ref.watch(notificationServiceProvider),
    voicePort: ref.watch(voiceServiceProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final handleEscalationCheckProvider = Provider<HandleEscalationCheck>((ref) {
  return HandleEscalationCheck(
    repository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

// ──────────────────────────────────────────────────────────────────────────────
// Medication providers (Phase 3B — Medication Logic)
// ──────────────────────────────────────────────────────────────────────────────

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  final databaseAsync = ref.watch(databaseProvider);
  return databaseAsync.when(
    data: (db) => MedicationRepositoryImpl(
      db.medicationDao,
      MedicationMapper(),
    ),
    loading: () => throw Exception('Database not initialized'),
    error: (e, st) => throw Exception('Database error: $e'),
  );
});

final doseQueryPortProvider = Provider<DoseQueryPort>((ref) {
  final databaseAsync = ref.watch(databaseProvider);
  return databaseAsync.when(
    data: (db) => MedicationRepositoryImpl(
      db.medicationDao,
      MedicationMapper(),
    ),
    loading: () => throw Exception('Database not initialized'),
    error: (e, st) => throw Exception('Database error: $e'),
  );
});

final addMedicationProvider = Provider<AddMedication>((ref) {
  return AddMedication(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    reminderGenerator: ref.watch(reminderGeneratorProvider),
    alarmScheduler: ref.watch(alarmSchedulerProvider),
  );
});

final reminderGeneratorProvider = Provider<ReminderGenerator>((ref) {
  return ReminderGenerator(
    reminderRepository: ref.watch(reminderRepositoryProvider),
    medicationRepository: ref.watch(medicationRepositoryProvider),
  );
});

final alarmSchedulerProvider = Provider<AlarmScheduler>((ref) {
  return AlarmScheduler(
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final recordDoseProvider = Provider<RecordDose>((ref) {
  return RecordDose(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    reminderRepository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final undoDoseProvider = Provider<UndoDose>((ref) {
  return UndoDose(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    reminderRepository: ref.watch(reminderRepositoryProvider),
    alarmPort: ref.watch(alarmServiceProvider),
  );
});

final getMedicationScheduleProvider = Provider<GetMedicationSchedule>((ref) {
  return GetMedicationSchedule(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    reminderRepository: ref.watch(reminderRepositoryProvider),
  );
});

final getAdherenceStatsProvider = Provider<GetAdherenceStats>((ref) {
  return GetAdherenceStats(
    repository: ref.watch(medicationRepositoryProvider),
  );
});
