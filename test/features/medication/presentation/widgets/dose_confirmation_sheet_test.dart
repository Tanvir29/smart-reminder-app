import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: child,
          ),
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

    testWidgets('shows Done button initially for non-critical medication',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: testSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Swipe to confirm'), findsNothing);
    });

    testWidgets('shows Done button initially for critical medication',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            slot: criticalSlot,
            onConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Critical Medication'), findsNothing);
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

      expect(find.text('Confirm Dose (0/3)'), findsNothing);
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

    group('Swipe-to-confirm gesture', () {
      testWidgets(
        'swipe to >85% threshold triggers onConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                slot: testSlot,
                onStartConfirmation: () {},
                onConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Done'));
          await tester.pumpAndSettle();

          expect(find.text('Swipe to confirm'), findsOneWidget);

          final slider = find.byType(GestureDetector).last;
          await tester.drag(slider, const Offset(300, 0));
          await tester.pumpAndSettle();

          expect(confirmed, isTrue);
        },
      );

      testWidgets(
        'swipe to <85% threshold does NOT trigger onConfirmed (snaps back)',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                slot: testSlot,
                onStartConfirmation: () {},
                onConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Done'));
          await tester.pumpAndSettle();

          final slider = find.byType(GestureDetector).last;
          await tester.drag(slider, const Offset(50, 0));
          await tester.pumpAndSettle();

          expect(confirmed, isFalse);
          expect(find.text('Swipe to confirm'), findsOneWidget);
        },
      );
    });

    group('Tap-3x challenge gesture', () {
      testWidgets(
        '3 sequential taps triggers onConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                slot: criticalSlot,
                onStartConfirmation: () {},
                onConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Done'));
          await tester.pumpAndSettle();

          expect(find.text('Critical Medication'), findsOneWidget);
          expect(find.text('Confirm Dose (0/3)'), findsOneWidget);

          await tester.tap(find.text('Confirm Dose (0/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm Dose (1/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm Dose (2/3)'));
          await tester.pumpAndSettle();

          expect(confirmed, isTrue);
        },
      );

      testWidgets(
        '2 taps only does NOT trigger onConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                slot: criticalSlot,
                onStartConfirmation: () {},
                onConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Done'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Confirm Dose (0/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm Dose (1/3)'));
          await tester.pumpAndSettle();

          expect(confirmed, isFalse);
          expect(find.text('Confirm Dose (2/3)'), findsOneWidget);
        },
      );
    });
  });
}
