// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:promptly/main.dart';

void main() {
  testWidgets('Promptly app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PromptlyApp());

    // Verify that the app starts with the home screen
    expect(find.text('Promptly'), findsOneWidget);
    expect(find.text('AI-Powered Productivity Tools'), findsOneWidget);
    expect(find.text('Professional Rewriting'), findsOneWidget);
    expect(find.text('Translation'), findsOneWidget);
    expect(find.text('Quran Mode'), findsOneWidget);
    expect(find.text('Custom Prompts'), findsOneWidget);
  });
}
