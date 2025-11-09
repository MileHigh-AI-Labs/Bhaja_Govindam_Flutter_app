// This is a basic Flutter widget test for the Bhaja Govindam app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  testWidgets('App builds and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async operations to complete
    await tester.pumpAndSettle();

    // Verify that the home screen displays the greeting text "Seeker!"
    expect(find.text('Seeker!'), findsOneWidget);

    // Verify that the "Start Reading" button is present
    expect(find.text('Start Reading'), findsOneWidget);

    // Verify that the app title is present
    expect(find.text('Shikshak DP'), findsOneWidget);
  });

  testWidgets('Navigate to shloka list screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async operations to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startButton = find.text('Start Reading');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);

    // Wait for navigation animation and page load
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam home page
    // Look for the title "Bhaja Govindam"
    expect(find.text('Bhaja Govindam'), findsOneWidget);

    // Verify that the subtitle is present
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });
}
