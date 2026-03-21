import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/theme/app_theme.dart';

void main() {
  testWidgets('Theme can build a basic app shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(body: Center(child: Text('QA smoke'))),
      ),
    );

    expect(find.text('QA smoke'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
