import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:increment_jackpot_app/main.dart';

void main() {
  testWidgets('Counter increments and jackpot functionality',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify initial state.
    expect(find.text('Current Counter: 0'), findsOneWidget);
    expect(find.text('Status: Even'), findsOneWidget);
    expect(find.text('Odd'), findsNothing);

    // Tap the "Increment Counter" button.
    await tester.tap(find.text('Increament Counter'));
    await tester.pump();

    // Verify the counter increments.
    expect(find.text('Current Counter: 1'), findsOneWidget);
    expect(find.text('Status: Odd'), findsOneWidget);

    // Simulate multiple taps to check jackpot.
    for (int i = 0; i < 20; i++) {
      await tester.tap(find.text('Increament Counter'));
      await tester.pump();
    }

    // Check for jackpot dialog appearance if applicable.
    if (find.byType(AlertDialog).evaluate().isNotEmpty) {
      expect(find.text('Selamat!'), findsOneWidget);
    }
  });
}
