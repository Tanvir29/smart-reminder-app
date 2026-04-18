import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/dose.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_notifier.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/adherence_dashboard_page.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/adherence_chart.dart';

class _EmptyMedicationNotifier extends MedicationNotifier {
  @override
  Future<MedicationState> build() async => const MedicationState();
}

class _LoadingMedicationNotifier extends MedicationNotifier {
  final Completer<MedicationState> _completer = Completer<MedicationState>();

  @override
  Future<MedicationState> build() => _completer.future;
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

  group('AdherenceDashboardPage', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _EmptyMedicationNotifier()),
          ],
          child: const MaterialApp(home: AdherenceDashboardPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Adherence'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _LoadingMedicationNotifier()),
          ],
          child: const MaterialApp(home: AdherenceDashboardPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows adherence percentage with data', (tester) async {
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
          child: const MaterialApp(home: AdherenceDashboardPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('100%'), findsWidgets);
      expect(find.text('Today'), findsWidgets);
    });

    testWidgets('shows stat cards with correct labels', (tester) async {
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
          child: const MaterialApp(home: AdherenceDashboardPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Taken'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
    });

    testWidgets('shows This Week section with AdherenceChart', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationNotifierProvider
                .overrideWith(() => _EmptyMedicationNotifier()),
          ],
          child: const MaterialApp(home: AdherenceDashboardPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('This Week'), findsOneWidget);
      expect(find.byType(AdherenceChart), findsOneWidget);
    });
  });
}
