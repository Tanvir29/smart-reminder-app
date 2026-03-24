import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_reminder_app/app/di/injection.dart';
import 'package:smart_reminder_app/core/platform/alarm_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Setup Hardware Reliability Test', (tester) async {
    final container = ProviderContainer();
    
    // Initialize services
    final alarmService = container.read(alarmServiceProvider);
    await alarmService.init();

    final alarmTime = DateTime.now().add(const Duration(minutes: 3));
    
    print('🚀 Setting alarm for: $alarmTime');
    
    final success = await alarmService.setAlarm(
      id: 999,
      dateTime: alarmTime,
      notificationTitle: "RELIABILITY TEST",
      notificationBody: "If you see this, the test passed.",
    );

    expect(success, isTrue);
    print('✅ Alarm set. You now have 3 minutes to perform OS-level tests.');
    
    // Keep the test alive so the app doesn't close immediately
    await Future.delayed(const Duration(minutes: 4));
  });
}