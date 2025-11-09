// Widget tests for the Bhaja Govindam Flutter App
//
// This test file validates the core functionality of the Bhaja Govindam app,
// which displays 33 sacred verses (shlokas) from Adi Shankaracharya's
// devotional composition.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  testWidgets('App builds and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the app bar or main title contains expected text
    // The app should display "Shikshak DP" somewhere on the home screen
    expect(find.textContaining('Shikshak DP'), findsWidgets);

    // Verify that the greeting text is displayed
    // The greeting should be one of: "Good Morning", "Good Afternoon", "Good Evening", "Good Night"
    final greetingFinder = find.byWidgetPredicate(
      (widget) => widget is Text &&
        (widget.data?.contains('Good Morning') == true ||
         widget.data?.contains('Good Afternoon') == true ||
         widget.data?.contains('Good Evening') == true ||
         widget.data?.contains('Good Night') == true),
    );
    expect(greetingFinder, findsAtLeastNWidgets(1));

    // Verify the "Seeker!" text is displayed
    expect(find.text('Seeker!'), findsOneWidget);
  });

  testWidgets('Home screen displays Start Reading button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the "Start Reading" button is present
    expect(find.text('Start Reading'), findsOneWidget);

    // Verify that BHAJA GOVINDAM text is present
    expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
  });

  testWidgets('App displays correct verse count', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the app mentions 33 sacred verses
    expect(find.textContaining('33 Sacred Verses'), findsOneWidget);
  });
}
