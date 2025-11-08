// This is a widget test for the Bhaja Govindam Flutter app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shikshak_dp/main.dart';

void main() {
  testWidgets('App loads and shows HomeScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Verify that the app shows the Shikshak DP title
    expect(find.text('Shikshak DP'), findsOneWidget);

    // Verify that a greeting is shown (Good Morning, Good Afternoon, Good Evening, or Good Night)
    final greetingFinder = find.byWidgetPredicate(
      (widget) => widget is Text &&
        (widget.data == 'Good Morning' ||
         widget.data == 'Good Afternoon' ||
         widget.data == 'Good Evening' ||
         widget.data == 'Good Night'),
    );
    expect(greetingFinder, findsOneWidget);

    // Verify that "Seeker!" text is shown
    expect(find.text('Seeker!'), findsOneWidget);
  });

  testWidgets('HomeScreen shows Start Reading button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Verify that "Start Reading" button is present
    expect(find.text('Start Reading'), findsOneWidget);

    // Verify that "BHAJA GOVINDAM" title is present
    expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
  });

  testWidgets('Tapping Start Reading navigates to Bhaja Govindam page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startReadingButton = find.text('Start Reading');
    expect(startReadingButton, findsOneWidget);

    await tester.tap(startReadingButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the Bhaja Govindam page
    // The BhajaGovindamHomePage shows "33 Sacred Verses by Adi Shankaracharya"
    expect(find.text('33 Sacred Verses by Adi Shankaracharya'), findsOneWidget);
  });
}
