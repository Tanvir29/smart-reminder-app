import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/app.dart';
import 'package:smart_reminder_app/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  try {
    await container.read(databaseProvider.future);

    final alarmService = container.read(alarmServiceProvider);
    final notificationService = container.read(notificationServiceProvider);

    await alarmService.init();
    await notificationService.init();

    // Wire HandleAlarmFired to alarm callback for lazy notification/voice construction
    final handleAlarmFired = container.read(handleAlarmFiredProvider);
    alarmService.onAlarmRing = (int alarmId, DateTime alarmDateTime) {
      handleAlarmFired.call(alarmId, alarmDateTime);
    };

    print('✅ Infrastructure Initialized');
  } catch (e) {
    print('❌ Initialization Failed: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SmartReminderApp(),
    ),
  );
}
