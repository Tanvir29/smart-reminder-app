import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/core/database/app_database.dart';
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

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
