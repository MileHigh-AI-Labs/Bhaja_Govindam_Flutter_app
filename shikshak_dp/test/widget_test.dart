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
  testWidgets('App loads and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app title "Shikshak DP" is displayed
    expect(find.text('Shikshak DP'), findsOneWidget);

    // Verify that the greeting is displayed (it should show one of the greetings)
    final greetingFinder = find.byWidgetPredicate((widget) =>
        widget is Text &&
        (widget.data == 'Good Morning' ||
         widget.data == 'Good Afternoon' ||
         widget.data == 'Good Evening' ||
         widget.data == 'Good Night'));
    expect(greetingFinder, findsOneWidget);

    // Verify that the "Seeker!" text is displayed
    expect(find.text('Seeker!'), findsOneWidget);

    // Verify that the main content "BHAJA GOVINDAM" is displayed
    expect(find.text('BHAJA GOVINDAM'), findsOneWidget);

    // Verify that the "Start Reading" button is present
    expect(find.text('Start Reading'), findsOneWidget);
  });

  testWidgets('Navigation to Bhaja Govindam page works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startButton = find.text('Start Reading');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);

    // Wait for the navigation animation and page load
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam page
    // The page should show "Bhaja Govindam" as the title
    expect(find.text('Bhaja Govindam'), findsWidgets);

    // Verify that the subtitle "33 Sacred Verses by Adi Shankaracharya" is displayed
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });

  testWidgets('Menu icon is present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Verify that the menu icon is present
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Verify that the notifications icon is present
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

    // Verify that the search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
