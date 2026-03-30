import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/dose_confirmation_sheet.dart';

void main() {
  group('DoseConfirmationSheet', () {
    late Medication testMedication;
    late Medication criticalMedication;
    late TodayDoseSlot testSlot;
    late TodayDoseSlot criticalSlot;

    setUp(() {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      testMedication = Medication(
        id: 'med-1',
        profileId: 'default',
        name: 'Aspirin',
        dosage: '100mg',
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
        instructions: 'Take with water',
        isCritical: false,
        xpValue: 10,
        createdAt: now,
        updatedAt: now,
      );

      criticalMedication = Medication(
        id: 'med-2',
        profileId: 'default',
        name: 'Insulin',
        dosage: '10 units',
        frequency: MedicationFrequency.daily(timesOfDay: const [480]),
        instructions: 'Critical medication',
        isCritical: true,
        xpValue: 25,
        createdAt: now,
        updatedAt: now,
      );

      testSlot = TodayDoseSlot(
        medication: testMedication,
        scheduledTimeMinutes: 480,
        scheduledTimeMs:
            DateTime.now().copyWith(hour: 8, minute: 0).millisecondsSinceEpoch,
        status: DoseSlotStatus.upcoming,
      );

      criticalSlot = TodayDoseSlot(
        medication: criticalMedication,
        scheduledTimeMinutes: 480,
        scheduledTimeMs:
            DateTime.now().copyWith(hour: 8, minute: 0).millisecondsSinceEpoch,
        status: DoseSlotStatus.upcoming,
      );
    });

    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('displays medication name and dosage', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('100mg'), findsOneWidget);
    });

    testWidgets('displays scheduled time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('8:00 AM'), findsOneWidget);
    });

    testWidgets('shows swipe-to-confirm for non-critical medication',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Swipe to confirm'), findsOneWidget);
      expect(find.text('Critical Medication'), findsNothing);
    });

    testWidgets('shows tap-3x challenge for critical medication',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: criticalSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Critical Medication'), findsOneWidget);
      expect(find.textContaining('more times'), findsOneWidget);
      expect(find.text('Confirm Dose (0/3)'), findsOneWidget);
    });

    testWidgets('tap-3x button displays initial count', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: criticalSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Confirm Dose (0/3)'), findsOneWidget);
      expect(find.textContaining('Critical Medication'), findsOneWidget);
    });

    testWidgets('has drag handle at top', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      final dragHandleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration != null &&
            (widget.decoration as BoxDecoration).borderRadius != null &&
            (widget.decoration as BoxDecoration).borderRadius ==
                BorderRadius.circular(2),
      );
      expect(dragHandleFinder, findsOneWidget);
    });

    testWidgets('displays medication icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.medication), findsOneWidget);
    });
  });
}
