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

    GroupedDoseSlot buildGroup(TodayDoseSlot slot) =>
        GroupedDoseSlot.fromSlots([slot]);

    testWidgets('displays medication name in checklist', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(testSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      expect(find.text('Aspirin'), findsOneWidget);
    });

    testWidgets('displays scheduled time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(testSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      expect(find.text('8:00 AM'), findsOneWidget);
    });

    testWidgets('shows progress indicator before all checked', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(testSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      expect(find.text('0 of 1 checked'), findsOneWidget);
    });

    testWidgets('shows Confirm All after checklist complete', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(testSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      // Tap the checklist item to check it
      await tester.tap(find.text('Aspirin'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm All'), findsOneWidget);
    });

    testWidgets('shows tap-3× challenge for critical medication',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(criticalSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      // Check the item first
      await tester.tap(find.text('Insulin'));
      await tester.pumpAndSettle();

      // Now should show Confirm All, tap it to start finalization
      await tester.tap(find.text('Confirm All'));
      await tester.pumpAndSettle();

      expect(find.text('Critical Medication'), findsOneWidget);
      expect(find.text('Confirm All (0/3)'), findsOneWidget);
    });

    testWidgets('has drag handle at top', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(testSlot),
            onAllConfirmed: () {},
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

    testWidgets('shows CRITICAL badge for critical medications',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          DoseConfirmationSheet(
            group: buildGroup(criticalSlot),
            onAllConfirmed: () {},
          ),
        ),
      );

      expect(find.text('CRITICAL'), findsOneWidget);
    });

    group('Swipe-to-confirm gesture', () {
      testWidgets(
        'swipe to >85% threshold triggers onAllConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                group: buildGroup(testSlot),
                onMedicationChecked: (_) {},
                onAllConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          // Check the checklist item
          await tester.tap(find.text('Aspirin'));
          await tester.pumpAndSettle();

          // Tap Confirm All to start finalization
          await tester.tap(find.text('Confirm All'));
          await tester.pumpAndSettle();

          expect(find.text('Swipe to confirm'), findsOneWidget);

          final slider = find.byType(GestureDetector).last;
          await tester.drag(slider, const Offset(300, 0));
          await tester.pumpAndSettle();

          expect(confirmed, isTrue);
        },
      );

      testWidgets(
        'swipe to <85% threshold does NOT trigger onAllConfirmed (snaps back)',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                group: buildGroup(testSlot),
                onMedicationChecked: (_) {},
                onAllConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Aspirin'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Confirm All'));
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
        '3 sequential taps triggers onAllConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                group: buildGroup(criticalSlot),
                onMedicationChecked: (_) {},
                onAllConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          // Check the checklist item
          await tester.tap(find.text('Insulin'));
          await tester.pumpAndSettle();

          // Tap Confirm All to start finalization
          await tester.tap(find.text('Confirm All'));
          await tester.pumpAndSettle();

          expect(find.text('Critical Medication'), findsOneWidget);
          expect(find.text('Confirm All (0/3)'), findsOneWidget);

          await tester.tap(find.text('Confirm All (0/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm All (1/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm All (2/3)'));
          await tester.pumpAndSettle();

          expect(confirmed, isTrue);
        },
      );

      testWidgets(
        '2 taps only does NOT trigger onAllConfirmed callback',
        (tester) async {
          bool confirmed = false;
          await tester.pumpWidget(
            buildTestWidget(
              DoseConfirmationSheet(
                group: buildGroup(criticalSlot),
                onMedicationChecked: (_) {},
                onAllConfirmed: () {
                  confirmed = true;
                },
              ),
            ),
          );

          await tester.tap(find.text('Insulin'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Confirm All'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Confirm All (0/3)'));
          await tester.pump();
          await tester.tap(find.text('Confirm All (1/3)'));
          await tester.pumpAndSettle();

          expect(confirmed, isFalse);
          expect(find.text('Confirm All (2/3)'), findsOneWidget);
        },
      );
    });
  });
}
