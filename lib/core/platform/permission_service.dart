import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  Future<bool> canScheduleExactAlarms() async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true;
    }
    await openAppSettings();
    return false;
  }

  Future<bool> requestBatteryOptimizationExemption() async {
    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isGranted) return true;
    final result = await Permission.ignoreBatteryOptimizations.request();
    return result.isGranted;
  }

  Future<Map<Permission, bool>> checkAllCritical() async {
    return {
      Permission.notification: await Permission.notification.status.isGranted,
      Permission.scheduleExactAlarm:
          await Permission.scheduleExactAlarm.status.isGranted,
      Permission.ignoreBatteryOptimizations:
          await Permission.ignoreBatteryOptimizations.status.isGranted,
    };
  }
}
