import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/domain/entities/medication.dart';
import 'package:smart_reminder_app/features/medication/presentation/notifiers/medication_state.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/medication_tile.dart';

void main() {
  group('MedicationTile', () {
    late Medication testMedication;

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
        createdAt: now,
        updatedAt: now,
      );
    });

    TodayDoseSlot createSlot(DoseSlotStatus status) {
      return TodayDoseSlot(
        medication: testMedication,
        scheduledTimeMinutes: 480,
        scheduledTimeMs:
            DateTime.now().copyWith(hour: 8, minute: 0).millisecondsSinceEpoch,
        status: status,
      );
    }

    testWidgets('displays medication name and dosage', (tester) async {
      final slot = createSlot(DoseSlotStatus.upcoming);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('100mg'), findsOneWidget);
    });

    testWidgets('displays formatted time', (tester) async {
      final slot = createSlot(DoseSlotStatus.upcoming);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.text('8:00 AM'), findsOneWidget);
    });

    testWidgets('shows check_circle icon for taken status', (tester) async {
      final slot = createSlot(DoseSlotStatus.taken);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows cancel icon for missed status', (tester) async {
      final slot = createSlot(DoseSlotStatus.missed);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('shows schedule icon for upcoming status', (tester) async {
      final slot = createSlot(DoseSlotStatus.upcoming);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('shows chevron for upcoming (actionable) slots',
        (tester) async {
      final slot = createSlot(DoseSlotStatus.upcoming);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('does not show chevron for taken slots', (tester) async {
      final slot = createSlot(DoseSlotStatus.taken);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('calls onTap when upcoming slot is tapped', (tester) async {
      var tapped = false;
      final slot = createSlot(DoseSlotStatus.upcoming);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(
              slot: slot,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MedicationTile));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when taken slot is tapped',
        (tester) async {
      var tapped = false;
      final slot = createSlot(DoseSlotStatus.taken);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(
              slot: slot,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MedicationTile));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('applies strikethrough to medication name when taken',
        (tester) async {
      final slot = createSlot(DoseSlotStatus.taken);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MedicationTile(slot: slot),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Aspirin'));
      expect(textWidget.style?.decoration, equals(TextDecoration.lineThrough));
    });
  });
}
