import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reminder_app/features/medication/presentation/widgets/confetti_overlay.dart';

void main() {
  group('ConfettiOverlay', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  ConfettiOverlay(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ConfettiOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeast(1));
    });

    testWidgets('calls onComplete after animation finishes', (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: Stack(
                children: [
                  ConfettiOverlay(onComplete: () => completed = true),
                ],
              ),
            ),
          ),
        ),
      );

      expect(completed, isFalse);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(completed, isTrue);
    });
  });
}
