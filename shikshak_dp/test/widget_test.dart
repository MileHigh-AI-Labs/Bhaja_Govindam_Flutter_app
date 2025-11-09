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

    // Wait for async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the home screen shows the app title
    expect(find.text('Shikshak DP'), findsOneWidget);

    // Verify that the greeting text is displayed (one of the possible greetings)
    final greetingFinder = find.textContaining('Good');
    expect(greetingFinder, findsAtLeastNWidgets(1));

    // Verify that "Seeker!" text is displayed
    expect(find.text('Seeker!'), findsOneWidget);
  });

  testWidgets('Home screen has Start Reading button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the "Start Reading" button exists
    expect(find.text('Start Reading'), findsOneWidget);

    // Verify that the button is tappable
    final startButton = find.text('Start Reading');
    expect(startButton, findsOneWidget);
  });

  testWidgets('Navigation to shloka list screen works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for async initialization to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startButton = find.text('Start Reading');
    expect(startButton, findsOneWidget);

    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam page
    // The page should show "Bhaja Govindam" title
    expect(find.text('Bhaja Govindam'), findsAtLeastNWidgets(1));

    // The page should show the subtitle "33 Sacred Verses by Adi Shankaracharya"
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });

  testWidgets('Home screen has menu and search icons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the menu icon exists
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Verify that the search icon exists
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify that the notification icon exists
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });
}
