import 'package:cozy_focus/cozy_focus.dart';
import 'package:cozy_focus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home shows timer, START, SET, SETTINGS', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const CozyFocusApp(initialSessionConfig: CozyFocusConfig.demoDefault),
    );

    expect(find.text('Cozy Focus'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('FOCUS SESSION'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('SET'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);
  });

  testWidgets('START then PAUSE; timer ticks', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const CozyFocusApp(initialSessionConfig: CozyFocusConfig.demoDefault),
    );

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

  testWidgets('SET from idle opens D4 modal with sliders and confirm', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const CozyFocusApp(initialSessionConfig: CozyFocusConfig.demoDefault),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('SET'));
    await tester.pumpAndSettle();

    expect(find.text('Set your flow'), findsOneWidget);
    expect(find.byKey(const Key('set_flow_work_slider')), findsOneWidget);
    expect(find.byKey(const Key('set_flow_break_slider')), findsOneWidget);
    expect(find.byKey(const Key('set_flow_cap_slider')), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
  });

  testWidgets('SET confirm saves prefs and applies lengths', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const CozyFocusApp(initialSessionConfig: CozyFocusConfig.demoDefault),
    );
    await tester.pumpAndSettle();

    expect(find.text('06:00'), findsNothing);

    await tester.tap(find.text('SET'));
    await tester.pumpAndSettle();

    final slider = find.byKey(const Key('set_flow_work_slider'));
    await tester.drag(slider, const Offset(-240, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final loaded = CozyFocusFlowPrefs.load(prefs);
    expect(loaded!.workMinutes, lessThan(25));

    await tester.pumpWidget(CozyFocusApp(initialSessionConfig: loaded));
    await tester.pumpAndSettle();

    final mmss =
        '${loaded.workMinutes.toString().padLeft(2, '0')}:00';
    expect(find.text(mmss), findsOneWidget);

    expect(loaded.breakMinutes, 5);
  });
}
