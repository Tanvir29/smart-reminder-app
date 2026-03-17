import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
import 'package:smart_reminder_app/core/engine/data/mappers/reminder_mapper.dart';
import 'package:smart_reminder_app/core/engine/data/repositories/reminder_repository_impl.dart';
import 'package:smart_reminder_app/core/engine/domain/repositories/reminder_repository.dart';
import 'package:smart_reminder_app/core/security/data/secure_storage_impl.dart';
import 'package:smart_reminder_app/core/security/domain/repositories/secure_storage_repository.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:smart_reminder_app/core/platform/notification_service.dart';

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
