import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/app.dart';
import 'package:smart_reminder_app/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Create the container that will actually be used by the app
  final container = ProviderContainer();

  // 2. Initialize your async services using THAT container
  try {
    // This triggers the DB open logic
    await container.read(databaseProvider.future);
    
    final alarmService = container.read(alarmServiceProvider);
    final notificationService = container.read(notificationServiceProvider);

    await alarmService.init();
    await notificationService.init();
    
    print('✅ Infrastructure Initialized');
  } catch (e) {
    print('❌ Initialization Failed: $e');
  }

  runApp(
    // 3. Pass the ALREADY INITIALIZED container to the scope
    UncontrolledProviderScope(
      container: container,
      child: const SmartReminderApp(),
    ),
  );
}
