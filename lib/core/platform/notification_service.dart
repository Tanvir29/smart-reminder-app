import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_reminder_app/core/engine/domain/ports/notification_port.dart';

class NotificationService implements NotificationPort {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Function(NotificationResponse)? onNotificationTap;

  /// Callback for action button presses (Snooze/Done).
  /// Parameters: action name, reminder ID from payload.
  Function(String action, String? reminderId)? onActionPressed;

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.actionId == 'snooze_all') {
      onActionPressed?.call('snooze_all', response.payload);
    } else if (response.actionId == 'view_take') {
      onActionPressed?.call('view_take', response.payload);
    } else if (response.actionId == 'snooze') {
      onActionPressed?.call('snooze', response.payload);
    } else if (response.actionId == 'done') {
      onActionPressed?.call('done', response.payload);
    } else {
      onNotificationTap?.call(response);
    }
  }

  Future<void> showMedicationReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isCritical = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Medication Reminders',
      channelDescription:
          'Notifications for medication reminders with Snooze All/View Take actions',
      importance: Importance.high,
      priority: Priority.high,
      fullScreenIntent: isCritical,
      actions: const [
        AndroidNotificationAction('snooze_all', 'Snooze All'),
        AndroidNotificationAction('view_take', 'View/Take'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showCycleReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'cycle_reminders',
      'Cycle Reminders',
      channelDescription: 'Cycle tracking reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showSystemNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'system',
      'System',
      channelDescription: 'Backup completion, streak notifications',
      importance: Importance.low,
      priority: Priority.low,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
