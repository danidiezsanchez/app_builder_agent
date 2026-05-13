import 'package:cozy_focus/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home shows timer, START, SET, SETTINGS', (WidgetTester tester) async {
    await tester.pumpWidget(const CozyFocusApp());

    expect(find.text('Cozy Focus'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('FOCUS SESSION'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('SET'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);
  });

  testWidgets('START then PAUSE; timer ticks', (WidgetTester tester) async {
    await tester.pumpWidget(const CozyFocusApp());

    await tester.tap(find.text('START'));
    await tester.pump();

    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('24:58'), findsOneWidget);

    await tester.tap(find.text('PAUSE'));
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('24:58'), findsOneWidget);
  });

  testWidgets('SET from idle opens D4 placeholder dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const CozyFocusApp());

    await tester.tap(find.text('SET'));
    await tester.pumpAndSettle();

    expect(find.text('Set your flow'), findsOneWidget);
    expect(find.textContaining('D4'), findsOneWidget);
  });
}
