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
  testWidgets('Bhaja Govindam app loads home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle();

    // Verify that the home screen displays key elements
    expect(find.text('Seeker!'), findsOneWidget);
    expect(find.text('BHAJA GOVINDAM'), findsOneWidget);
    expect(find.text('SHLOKAS'), findsOneWidget);
  });

  testWidgets('Start Reading button navigates to shloka list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for all animations and async operations to complete
    await tester.pumpAndSettle();

    // Find and tap the "Start Reading" button
    final startReadingButton = find.text('Start Reading');
    expect(startReadingButton, findsOneWidget);

    await tester.tap(startReadingButton);
    await tester.pumpAndSettle();

    // Verify that we navigated to the BhajaGovindamHomePage
    // which should display the title "Bhaja Govindam"
    expect(find.text('Bhaja Govindam'), findsWidgets);
  });
}
