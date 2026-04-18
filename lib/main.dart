import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/app.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/core/engine/domain/entities/reminder_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  try {
    await container.read(databaseProvider.future);

    final alarmService = container.read(alarmServiceProvider);
    final notificationService = container.read(notificationServiceProvider);

    await alarmService.init();
    await notificationService.init();
    final voiceService = container.read(voiceServiceProvider);
    await voiceService.init();

    final handleAlarmFired = container.read(handleAlarmFiredProvider);
    final handleEscalationCheck = container.read(handleEscalationCheckProvider);
    final handleSnooze = container.read(handleSnoozeProvider);
    final confirmReminder = container.read(confirmReminderProvider);
    final reminderRepository = container.read(reminderRepositoryProvider);

    alarmService.onAlarmRing = (int alarmId, DateTime alarmDateTime) {
      final reminderId = alarmService.getReminderIdForEscalationAlarm(alarmId);
      if (reminderId != null) {
        handleEscalationCheck.call(reminderId);
      } else {
        handleAlarmFired.call(alarmId, alarmDateTime);
      }
    };

    notificationService.onActionPressed =
        (String action, String? reminderId) async {
      if (reminderId == null) return;
      switch (action) {
        case 'snooze_all':
        case 'snooze':
          await handleSnooze.call(reminderId);
        case 'view_take':
        case 'done':
          final reminder = await reminderRepository.getById(reminderId);
          if (reminder != null &&
              (reminder.status == ReminderStatus.triggered ||
                  reminder.status == ReminderStatus.confirmationRequired)) {
            await confirmReminder.call(reminderId);
          }
      }
    };

    debugPrint('Infrastructure Initialized');
  } catch (e) {
    debugPrint('Initialization Failed: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SmartReminderApp(),
    ),
  );
}
