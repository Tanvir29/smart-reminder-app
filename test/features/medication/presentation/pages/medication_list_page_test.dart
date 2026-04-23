import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/medication_list_page.dart';

class _EmptyMedicationNotifier extends MedicationNotifier {
  @override
  Future<MedicationState> build() async => const MedicationState();
}

class _LoadingMedicationNotifier extends MedicationNotifier {
  final Completer<MedicationState> _completer = Completer<MedicationState>();

  @override
  Future<MedicationState> build() => _completer.future;
}

class _ErrorMedicationNotifier extends MedicationNotifier {
  @override
  Future<MedicationState> build() async {
    throw Exception('Test error');
  }
}

class _DataMedicationNotifier extends MedicationNotifier {
  final MedicationState testState;

  _DataMedicationNotifier(this.testState);

  @override
  Future<MedicationState> build() async => testState;
}

void main() {
  final now = DateTime.now();
  final dateStart =
      DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

  Medication createTestMedication({
    String id = 'med-1',
    String name = 'Aspirin',
    List<int> timesOfDay = const [480],
  }) {
    return Medication(
      id: id,
      profileId: 'default',
      name: name,
      dosage: '100mg',
      frequency: MedicationFrequency.daily(timesOfDay: timesOfDay),
      createdAt: now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
    );
  }

  DoseRecord createTestDoseRecord({
    String id = 'dose-1',
    String medicationId = 'med-1',
    required int scheduledTime,
    DoseStatus status = DoseStatus.taken,
  }) {
    return DoseRecord(
      id: id,
      profileId: 'default',
      medicationId: medicationId,
      scheduledTime: scheduledTime,
      status: status,
      createdAt: now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
    );
  }

  group('MedicationListPage', () {
    testWidgets('shows loading indicator when data is loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _LoadingMedicationNotifier()),
          ],
          child: const MaterialApp(home: MedicationListPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no medications', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _EmptyMedicationNotifier()),
          ],
          child: const MaterialApp(home: MedicationListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No medications yet'), findsOneWidget);
      expect(find.text('Tap + to add your first medication'), findsOneWidget);
    });

    testWidgets('shows dashboard header with data', (tester) async {
      final scheduledMs = dateStart + 480 * 60 * 1000;
      final med = createTestMedication();
      final dose = createTestDoseRecord(
          scheduledTime: scheduledMs, status: DoseStatus.taken);
      final testState = MedicationState(
        medications: [med],
        todaysDoses: [dose],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _DataMedicationNotifier(testState)),
          ],
          child: const MaterialApp(home: MedicationListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("Today's Meds"), findsOneWidget);
      expect(find.text('Aspirin'), findsOneWidget);
    });

    testWidgets('shows Add Med FAB', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _EmptyMedicationNotifier()),
          ],
          child: const MaterialApp(home: MedicationListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Med'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows error state with retry on provider error',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _ErrorMedicationNotifier()),
          ],
          child: const MaterialApp(home: MedicationListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Could not load medications'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
