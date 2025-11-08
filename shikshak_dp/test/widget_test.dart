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
  testWidgets('Bhaja Govindam app loads and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow time for async operations (like notification service initialization)
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Shikshak DP'), findsOneWidget);

    // Verify that the greeting is displayed (one of the possible greetings)
    final greetingFinder = find.textContaining('Good', findRichText: true);
    expect(greetingFinder, findsAtLeastNWidgets(1));

    // Verify that "Seeker!" text is displayed
    expect(find.text('Seeker!'), findsOneWidget);

    // Verify that the Om symbol watermark is present
    expect(find.text('ॐ'), findsWidgets);

    // Verify that the "Start Reading" button exists
    expect(find.text('Start Reading'), findsOneWidget);

    // Verify that menu, notification, and search icons are present
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('Navigation to Bhaja Govindam list screen works', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startReadingButton = find.text('Start Reading');
    expect(startReadingButton, findsOneWidget);

    await tester.tap(startReadingButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam list screen
    expect(find.text('Bhaja Govindam'), findsOneWidget);
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);

    // Verify that back button exists
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('Shloka grid displays correctly', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Navigate to the Bhaja Govindam list screen
    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();

    // Verify that at least some shloka cards are displayed
    // The first shloka should have the label "Worship Govinda"
    expect(find.text('Worship Govinda'), findsOneWidget);

    // Verify that shloka numbers are displayed
    expect(find.text('Shloka 1'), findsOneWidget);

    // Since it's a grid, we should find multiple shloka cards
    // Let's check for a few more
    expect(find.textContaining('Shloka'), findsWidgets);
  });
}
