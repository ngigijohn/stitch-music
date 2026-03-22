import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/screens/home_screen.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('home exposes quick actions semantics label', (tester) async {
    await tester.pumpWidget(
      buildTestableApp(
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Open quick actions',
      ),
      findsOneWidget,
    );
  });
}
