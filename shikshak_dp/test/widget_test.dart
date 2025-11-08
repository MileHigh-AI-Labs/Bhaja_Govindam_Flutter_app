// Widget tests for Bhaja Govindam Flutter App
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';
import 'package:shikshak_dp/model/shloka_model.dart';

void main() {
  group('Bhaja Govindam App Tests', () {
    testWidgets('App loads and displays home screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the home screen elements are present
      expect(find.text('Shikshak DP'), findsOneWidget);
      expect(find.text('Seeker!'), findsOneWidget);

      // Verify greeting is displayed (one of the time-based greetings)
      final greetingFinder = find.textContaining('Good');
      expect(greetingFinder, findsOneWidget);

      // Verify the main call-to-action button is present
      expect(find.text('Start Reading'), findsOneWidget);
    });

    testWidgets('Navigation to Bhaja Govindam list works', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap the "Start Reading" button
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Verify we navigated to the list screen
      expect(find.text('Bhaja Govindam'), findsOneWidget);
      expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
    });

    testWidgets('Shloka list displays correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to the list
      await tester.tap(find.text('Start Reading'));
      await tester.pumpAndSettle();

      // Verify that grid cards are displayed
      expect(find.text('Shloka 1'), findsOneWidget);
      expect(find.text('Worship Govinda'), findsOneWidget);
    });

    testWidgets('Drawer menu opens and contains menu items', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify drawer items
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Share the App'), findsOneWidget);
      expect(find.text('Visit Us'), findsOneWidget);
    });

    testWidgets('Search button is present', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify search icon is present
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('Shloka Model Tests', () {
    test('Shloka.fromJson parses correctly', () {
      final json = {
        'Shloka no.': 'Shloka 1',
        'Devanagari': 'भज गोविन्दं',
        ' Transliteration': 'bhaja govindaṃ',
        'Word-to-Word Meaning': 'भज (bhaja) – worship',
        'Commentary': 'This verse presents...',
        'Audio URL': 'PWa7Fv4nX6A'
      };

      final shloka = Shloka.fromJson(json);

      expect(shloka.shlokaNo, 'Shloka 1');
      expect(shloka.devanagari, 'भज गोविन्दं');
      expect(shloka.transliteration, 'bhaja govindaṃ');
      expect(shloka.wordToWordMeaning, 'भज (bhaja) – worship');
      expect(shloka.commentary, 'This verse presents...');
      expect(shloka.audioUrl, 'PWa7Fv4nX6A');
    });

    test('Shloka.fromJson handles missing audio URL', () {
      final json = {
        'Shloka no.': 'Shloka 1',
        'Devanagari': 'भज गोविन्दं',
        ' Transliteration': 'bhaja govindaṃ',
        'Word-to-Word Meaning': 'भज (bhaja) – worship',
        'Commentary': 'This verse presents...',
      };

      final shloka = Shloka.fromJson(json);

      expect(shloka.shlokaNo, 'Shloka 1');
      expect(shloka.audioUrl, null);
    });
  });

  group('JSON Data Validation', () {
    test('loadShlokas returns 33 shlokas', () async {
      final shlokas = await loadShlokas();
      expect(shlokas.length, 33);
    });

    test('All shlokas have required fields', () async {
      final shlokas = await loadShlokas();

      for (final shloka in shlokas) {
        expect(shloka.shlokaNo.isNotEmpty, true);
        expect(shloka.devanagari.isNotEmpty, true);
        expect(shloka.transliteration.isNotEmpty, true);
        expect(shloka.wordToWordMeaning.isNotEmpty, true);
        expect(shloka.commentary.isNotEmpty, true);
      }
    });
  });
}
