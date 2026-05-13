import 'package:cozy_focus/cozy_focus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CozyFocusSessionEngine', () {
    test('legal path: IDLE → focus run/pause/resume → break fires chime once', () {
      var chimes = 0;
      final engine = CozyFocusSessionEngine(
        config: const CozyFocusConfig(
          workMinutes: 1,
          breakMinutes: 1,
          sessionCapHours: 8,
        ),
        onBreakChime: () => chimes++,
      );
      addTearDown(engine.dispose);

      expect(engine.tryStart(), isTrue);
      expect(engine.state, CozyFocusFsmState.focusRunning);

      expect(engine.tryPause(), isTrue);
      expect(engine.state, CozyFocusFsmState.focusPaused);

      expect(engine.tryResume(), isTrue);
      expect(engine.state, CozyFocusFsmState.focusRunning);

      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.breakRunning);
      expect(chimes, 1);
      expect(engine.phaseLabel, 'REST SESSION');
    });

    test('illegal transitions return false', () {
      final engine = CozyFocusSessionEngine(
        config: const CozyFocusConfig(
          workMinutes: 1,
          breakMinutes: 1,
          sessionCapHours: 1,
        ),
      );
      addTearDown(engine.dispose);

      expect(engine.tryPause(), isFalse);
      expect(engine.tryResume(), isFalse);
      expect(engine.tryFinish(), isFalse);

      expect(engine.tryStart(), isTrue);
      expect(engine.tryStart(), isFalse);

      expect(engine.tryResume(), isFalse);
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.breakRunning);
      expect(engine.tryResume(), isFalse);
    });

    test('session cap: finish current focus slice then SESSION_COMPLETE (no extra chime)', () {
      var chimes = 0;
      final engine = CozyFocusSessionEngine(
        config: const CozyFocusConfig(
          workMinutes: 1,
          breakMinutes: 1,
          sessionCapHours: 3 / 60, // 3 minutes = 180 s cap
        ),
        onBreakChime: () => chimes++,
      );
      addTearDown(engine.dispose);

      expect(engine.tryStart(), isTrue);

      // Slice 1 → break
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.breakRunning);
      expect(chimes, 1);

      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.focusRunning);

      // Slice 2 → break
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.breakRunning);
      expect(chimes, 2);

      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.focusRunning);

      // Slice 3 → cap reached after slice completes → complete (no break chime)
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.sessionComplete);
      expect(engine.remainingSeconds, 0);
      expect(chimes, 2);
      expect(engine.phaseLabel, '(session ended)');
      expect(engine.cumulativeFocusSeconds, 180);
    });

    test('FINISH → IDLE resets clock to configured work duration', () {
      final cfg = const CozyFocusConfig(
        workMinutes: 7,
        breakMinutes: 2,
        sessionCapHours: 1,
      );
      final engine = CozyFocusSessionEngine(
        config: const CozyFocusConfig(
          workMinutes: 1,
          breakMinutes: 1,
          sessionCapHours: 2 / 60,
        ),
      );
      addTearDown(engine.dispose);

      expect(engine.tryStart(), isTrue);
      engine.elapseSeconds(60);
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.focusRunning);
      engine.elapseSeconds(60);
      expect(engine.state, CozyFocusFsmState.sessionComplete);

      expect(engine.tryApplyConfig(cfg), isFalse);

      expect(engine.tryFinish(), isTrue);
      expect(engine.state, CozyFocusFsmState.idle);
      expect(engine.remainingSeconds, cfg.workSeconds);
      expect(engine.cumulativeFocusSeconds, 0);

      expect(engine.tryApplyConfig(cfg), isTrue);
      expect(engine.remainingSeconds, cfg.workSeconds);
    });

    test('snapshots stream emits on transitions', () async {
      final engine = CozyFocusSessionEngine(
        config: const CozyFocusConfig(
          workMinutes: 1,
          breakMinutes: 1,
          sessionCapHours: 8,
        ),
      );
      addTearDown(engine.dispose);

      final seen = <CozyFocusFsmState>[];
      final sub = engine.snapshots.listen((s) => seen.add(s.state));
      addTearDown(sub.cancel);

      engine.tryStart();
      engine.elapseSeconds(60);
      await Future<void>.delayed(Duration.zero);

      expect(seen, contains(CozyFocusFsmState.focusRunning));
      expect(seen, contains(CozyFocusFsmState.breakRunning));
    });
  });
}
