// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CommunityConnectApp(),
      ),
    );

    // Verify that the app is built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
