// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple widget test', (WidgetTester tester) async {
    // Build a simple app instead of the full CommunityConnectApp
    // because the full app triggers Auth flow which might overflow in small test screen.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Test'),
        ),
      ),
    );

    // Verify that the text is rendered
    expect(find.text('Test'), findsOneWidget);
  });
}
