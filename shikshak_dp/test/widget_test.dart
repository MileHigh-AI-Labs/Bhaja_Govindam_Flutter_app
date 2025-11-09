// Widget tests for the Bhaja Govindam Flutter app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Bhaja Govindam App Tests', () {
    testWidgets('App launches and displays home screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      // Verify that the home screen loads with expected text
      expect(find.text('Shikshak DP'), findsOneWidget);
      expect(find.text('Seeker!'), findsOneWidget);
    });

    testWidgets('Home screen displays greeting', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that one of the greetings is displayed
      // The greeting changes based on time of day
      final greetingFinder = find.byWidgetPredicate(
        (widget) => widget is Text &&
                    (widget.data == 'Good Morning' ||
                     widget.data == 'Good Afternoon' ||
                     widget.data == 'Good Evening' ||
                     widget.data == 'Good Night'),
      );

      expect(greetingFinder, findsOneWidget);
    });

    testWidgets('Home screen displays Bhaja Govindam card', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the main card displays key text
      expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
      expect(find.text('SHLOKAS'), findsOneWidget);
      expect(find.text('33 Sacred Verses Available Now'), findsOneWidget);
    });

    testWidgets('Start Reading button navigates to shloka list', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find and tap the "Start Reading" button
      final startButton = find.text('Start Reading');
      expect(startButton, findsOneWidget);

      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verify that we navigated to the shloka list screen
      expect(find.text('Bhaja Govindam'), findsWidgets);
      expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
    });

    testWidgets('Shloka list loads and displays shlokas', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to shloka list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Verify that shloka cards are displayed
      expect(find.text('Shloka 1'), findsOneWidget);
      expect(find.text('Worship Govinda'), findsOneWidget);

      // Verify that multiple shlokas are visible
      expect(find.textContaining('Shloka'), findsWidgets);
    });

    testWidgets('Tapping a shloka navigates to detail screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to shloka list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Tap on the first shloka card
      final firstShloka = find.text('Worship Govinda');
      expect(firstShloka, findsOneWidget);

      await tester.tap(firstShloka);
      await tester.pumpAndSettle();

      // Verify that we're on the detail screen
      // The detail screen should have toggle buttons
      expect(find.text('Devanagari'), findsOneWidget);
      expect(find.text('Transliteration'), findsOneWidget);
      expect(find.text('Word Meaning'), findsOneWidget);
      expect(find.text('Commentary'), findsOneWidget);
    });

    testWidgets('Navigation back button works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to shloka list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Verify we're on the list page
      expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);

      // Find and tap the back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we're back on the home screen
      expect(find.text('Seeker!'), findsOneWidget);
      expect(find.text('Start Reading'), findsOneWidget);
    });

    testWidgets('Search icon is displayed on home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify search icon is present
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Menu icon is displayed on home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify menu icon is present
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Notification icon is displayed on home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify notification icon is present
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });
  });
}
