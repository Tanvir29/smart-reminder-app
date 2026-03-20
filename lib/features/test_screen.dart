import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reminder_app/app/di/injection.dart';

class HardwareTestScreen extends ConsumerWidget {
  const HardwareTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hardware Smoke Test")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final success = await ref.read(alarmServiceProvider).setAlarm(
                  id: 42,
                  dateTime: DateTime.now().add(const Duration(seconds: 10)),
                  notificationTitle: "Test Alarm",
                  notificationBody: "Does this ring?",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? "Alarm Set for +10s" : "Failed")),
                );
              },
              child: const Text("Trigger Alarm (+10s)"),
            ),
            ElevatedButton(
              onPressed: () => ref.read(alarmServiceProvider).stopAlarm(42),
              child: const Text("Stop Alarm"),
            ),
          ],
        ),
      ),
    );
  }
}