import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this
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

    // --- START OF TEST INJECTION ---
    await _runHardwareReliabilitySetup(alarmService);
    // --- END OF TEST INJECTION ---

    print('✅ Infrastructure Initialized & Test Alarm Scheduled');
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

/// Self-executing test logic for Points 3 and 4
Future<void> _runHardwareReliabilitySetup(dynamic alarmService) async {
  // 1. Request necessary permissions for Android 13+ and Android 15
  await [
    Permission.notification,
    Permission.scheduleExactAlarm,
    Permission.ignoreBatteryOptimizations, // Critical for Doze mode
  ].request();

  // 2. Schedule an alarm for 5 minutes from now.
  // This gives you time to unplug and run ADB commands or Reboot.
  final testTime = DateTime.now().add(const Duration(minutes: 5));

  await alarmService.setAlarm(
    id: 888,
    dateTime: testTime,
    notificationTitle: "🚨 RELIABILITY TEST",
    notificationBody: "If you hear this, your engine passed the test.",
  );

  print('🚀 TEST ALARM SET FOR: $testTime');
}
