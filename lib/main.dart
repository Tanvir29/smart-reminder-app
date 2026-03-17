import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/app.dart';
import 'package:smart_reminder_app/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(
    ProviderScope(
      child: SmartReminderApp(),
    ),
  );
}

Future<void> initializeDependencies() async {
  final container = ProviderContainer();

  final database = await container.read(databaseProvider.future);
  final alarmService = container.read(alarmServiceProvider);
  final notificationService = container.read(notificationServiceProvider);

  await alarmService.init();
  await notificationService.init();
}
