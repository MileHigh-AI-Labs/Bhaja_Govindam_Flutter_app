// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  testWidgets('Bhaja Govindam app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow async operations to complete (for services initialization)
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Shikshak DP'), findsOneWidget);

    // Verify that the greeting text is displayed
    expect(find.text('Seeker!'), findsOneWidget);

    // Verify that the Start Reading button is displayed
    expect(find.text('Start Reading'), findsOneWidget);
  });

  testWidgets('Navigation to Bhaja Govindam list works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow async operations to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startReadingButton = find.text('Start Reading');
    expect(startReadingButton, findsOneWidget);

    await tester.tap(startReadingButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam page
    expect(find.text('Bhaja Govindam'), findsOneWidget);
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });
}
