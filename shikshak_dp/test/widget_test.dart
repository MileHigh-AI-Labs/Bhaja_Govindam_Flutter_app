// Widget tests for Bhaja Govindam Flutter App
//
// These tests verify the core functionality of the Bhaja Govindam app,
// including the home screen UI, navigation to the shloka list, and
// proper loading of shloka data.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  // Setup: Mock asset loading for tests
  setUpAll(() {
    // Mock the notification service initialization
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('App loads home screen with key UI elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that key UI elements are present on the home screen
    expect(find.text('Shikshak DP'), findsOneWidget);
    expect(find.text('Seeker!'), findsOneWidget);

    // Verify the main content title is present
    expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
    expect(find.text('SHLOKAS'), findsOneWidget);

    // Verify the start reading button is present
    expect(find.text('Start Reading'), findsOneWidget);
  });

  testWidgets('Greeting changes based on time of day', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that one of the greetings is present
    final greetingFinder = find.byWidgetPredicate(
      (widget) => widget is Text &&
        (widget.data == 'Good Morning' ||
         widget.data == 'Good Afternoon' ||
         widget.data == 'Good Evening' ||
         widget.data == 'Good Night'),
    );

    expect(greetingFinder, findsOneWidget);
  });

  testWidgets('Navigation to Bhaja Govindam home page works', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap the "Start Reading" button
    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();

    // Verify navigation to the Bhaja Govindam page
    expect(find.text('Bhaja Govindam'), findsOneWidget);
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });

  testWidgets('Om symbol is displayed on home screen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the Om symbol (ॐ) is displayed
    expect(find.text('ॐ'), findsWidgets);
  });

  testWidgets('Search and notification icons are present', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify that the notifications icon is present
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('Menu icon opens drawer', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tap the menu icon
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify that drawer items are visible
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Share the App'), findsOneWidget);
    expect(find.text('Visit Us'), findsOneWidget);
  });
}
