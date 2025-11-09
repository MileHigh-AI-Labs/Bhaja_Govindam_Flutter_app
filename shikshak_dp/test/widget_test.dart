// Widget tests for Bhaja Govindam Flutter App
//
// These tests verify the core functionality of the Bhaja Govindam app,
// including the home screen, navigation, and shloka display.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bhaja Govindam App Tests', () {
    testWidgets('App builds and displays home screen', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify that the app builds without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home screen displays app title', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the app title is displayed
      expect(find.text('Shikshak DP'), findsOneWidget);
    });

    testWidgets('Home screen displays greeting', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that a greeting is displayed (time-based)
      final greetingFinder = find.textContaining(
        RegExp(r'Good (Morning|Afternoon|Evening|Night)'),
      );
      expect(greetingFinder, findsOneWidget);
    });

    testWidgets('Home screen displays "Seeker!" text', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that "Seeker!" text is displayed
      expect(find.text('Seeker!'), findsOneWidget);
    });

    testWidgets('Home screen displays Bhaja Govindam card', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the main content card is displayed
      expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
      expect(find.text('SHLOKAS'), findsOneWidget);
    });

    testWidgets('Home screen has Start Reading button', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the Start Reading button exists
      expect(find.text('Start Reading'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Home screen displays verse count', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the verse count is displayed
      expect(find.textContaining('33'), findsAtLeastNWidgets(1));
    });

    testWidgets('Home screen has menu button', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the menu button exists
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Home screen has search button', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the search button exists
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Home screen has notification button', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the notification button exists
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('Navigation to shloka list works', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find and tap the "Start Reading" button
      final startButton = find.text('Start Reading');
      expect(startButton, findsOneWidget);

      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verify that we navigated to the shloka list page
      expect(find.text('Bhaja Govindam'), findsAtLeastNWidgets(1));
    });

    testWidgets('Shloka list loads and displays shlokas', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to shloka list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Wait for shlokas to load
      await tester.pump(const Duration(seconds: 1));

      // Verify that shloka cards are displayed
      expect(find.textContaining('Shloka'), findsWidgets);
    });

    testWidgets('Drawer menu can be opened', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap the menu button to open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify that drawer menu items are displayed
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Share the App'), findsOneWidget);
      expect(find.text('Visit Us'), findsOneWidget);
    });

    testWidgets('About section is displayed', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Scroll to find the About section
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Verify that About section is displayed
      expect(find.text('About'), findsOneWidget);
      expect(find.textContaining('Adi Shankaracharya'), findsOneWidget);
    });
  });

  group('Shloka Data Loading Tests', () {
    testWidgets('Shlokas load from JSON successfully', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to shloka list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Give extra time for async data loading
      await tester.pump(const Duration(seconds: 2));

      // Verify no error messages are displayed
      expect(find.textContaining('Error'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
