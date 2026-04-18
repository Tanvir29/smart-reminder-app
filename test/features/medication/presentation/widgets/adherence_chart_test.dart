import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/adherence_chart.dart';

void main() {
  group('AdherenceChart', () {
    testWidgets('renders day labels for all 7 days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdherenceChart(
              weeklyAdherence: List.filled(7, 0.0),
            ),
          ),
        ),
      );

      expect(find.text('M'), findsOneWidget);
      expect(find.text('T'), findsNWidgets(2));
      expect(find.text('W'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
      expect(find.text('S'), findsNWidgets(2));
    });

    testWidgets('renders percentage text for days with data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdherenceChart(
              weeklyAdherence: [1.0, 0.8, 0.5, 0.0, 0.0, 0.0, 0.0],
            ),
          ),
        ),
      );

      expect(find.text('100%'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('does not render percentage for days with no data',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdherenceChart(
              weeklyAdherence: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            ),
          ),
        ),
      );

      expect(find.textContaining('%'), findsNothing);
    });

    testWidgets('renders correct number of bar containers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdherenceChart(
              weeklyAdherence: [0.5, 1.0, 0.0, 0.8, 0.3, 0.0, 0.9],
            ),
          ),
        ),
      );

      expect(find.byType(AdherenceChart), findsOneWidget);

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.children.length, equals(7));
    });
  });
}
