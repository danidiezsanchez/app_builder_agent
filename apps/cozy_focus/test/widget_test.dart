import 'package:flutter_test/flutter_test.dart';

import 'package:cozy_focus/main.dart';

void main() {
  testWidgets('Cozy shell shows title and body copy', (WidgetTester tester) async {
    await tester.pumpWidget(const CozyFocusApp());

    expect(find.text('Cozy Focus'), findsOneWidget);
    expect(find.textContaining('Shell ready'), findsOneWidget);
  });
}
