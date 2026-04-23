import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/add_medication_page.dart';

void main() {
  group('AddMedicationPage', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      expect(find.text('Add Medication'), findsOneWidget);
    });

    testWidgets('renders medication name input field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      expect(find.byType(TextFormField), findsAtLeast(1));
      expect(find.text('Medication Name'), findsOneWidget);
    });

    testWidgets('renders dosage input field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      expect(find.text('Dosage'), findsOneWidget);
    });

    testWidgets('renders frequency segmented buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      expect(find.text('Daily'), findsOneWidget);
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Interval'), findsOneWidget);
      expect(find.text('One-time'), findsOneWidget);
    });

    testWidgets('renders critical medication toggle', (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('shows validation errors on empty form submission',
        (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: const AddMedicationPage()),
        ),
      );

      await tester.tap(find.text('Save Medication'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsNWidgets(2));
    });
  });
}
