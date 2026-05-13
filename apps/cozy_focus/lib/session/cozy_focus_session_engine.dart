import 'dart:async';

import 'package:flutter/foundation.dart';

import 'audio_flags.dart';
import 'cozy_focus_config.dart';
import 'cozy_focus_fsm_state.dart';

/// Immutable view for UI / streams.
@immutable
class CozyFocusSnapshot {
  const CozyFocusSnapshot({
    required this.state,
    required this.remainingSeconds,
    required this.phaseLabel,
    required this.cumulativeFocusSeconds,
    required this.config,
  });

  final CozyFocusFsmState state;
  final int remainingSeconds;

  /// Main line under timer (spec table).
  final String phaseLabel;

  /// Summed completed focus slices this session (resets on FINISH → IDLE).
  final int cumulativeFocusSeconds;

  final CozyFocusConfig config;

  bool get isFocusPhase =>
      state == CozyFocusFsmState.idle ||
      state == CozyFocusFsmState.focusRunning ||
      state == CozyFocusFsmState.focusPaused;

  bool get isBreakPhase =>
      state == CozyFocusFsmState.breakRunning ||
      state == CozyFocusFsmState.breakPaused;
}

/// FSM + Pomodoro session cap (cumulative focus vs configured hours ceiling).
///
/// Session-complete rule (COZY_FOCUS.md): when cumulative focus would hit cap,
/// finish the **current** focus countdown, then enter [CozyFocusFsmState.sessionComplete]
/// (no break after that slice).
class CozyFocusSessionEngine extends ChangeNotifier {
  CozyFocusSessionEngine({
    CozyFocusConfig config = CozyFocusConfig.demoDefault,
    this.onBreakChime,
    this.onWorkGong,
  }) : _config = config {
    _remainingSeconds = _config.workSeconds;
    _notify();
  }

  CozyFocusConfig _config;
  CozyFocusConfig get config => _config;

  int _remainingSeconds = 0;
  int _cumulativeFocusSeconds = 0;
  CozyFocusFsmState _state = CozyFocusFsmState.idle;

  /// EV01 hook — fired once when entering break from a completed focus slice.
  final void Function()? onBreakChime;

  /// EV02 hook — only used when [kPlayGong] is true.
  final void Function()? onWorkGong;

  final StreamController<CozyFocusSnapshot> _snapshotController =
      StreamController<CozyFocusSnapshot>.broadcast(sync: true);

  /// Same data as [snapshot], pushed after each transition / tick.
  Stream<CozyFocusSnapshot> get snapshots => _snapshotController.stream;

  CozyFocusFsmState get state => _state;

  int get remainingSeconds => _remainingSeconds;

  int get cumulativeFocusSeconds => _cumulativeFocusSeconds;

  String get phaseLabel => _phaseLabelFor(_state);

  CozyFocusSnapshot get snapshot => CozyFocusSnapshot(
        state: _state,
        remainingSeconds: _remainingSeconds,
        phaseLabel: phaseLabel,
        cumulativeFocusSeconds: _cumulativeFocusSeconds,
        config: _config,
      );

  /// Apply new lengths only from IDLE (spec: next run / confirm from modal).
  bool tryApplyConfig(CozyFocusConfig next) {
    if (_state != CozyFocusFsmState.idle) return false;
    _config = next;
    _remainingSeconds = _config.workSeconds;
    _notify();
    return true;
  }

  bool get _running =>
      _state == CozyFocusFsmState.focusRunning ||
      _state == CozyFocusFsmState.breakRunning;

  bool get _paused =>
      _state == CozyFocusFsmState.focusPaused ||
      _state == CozyFocusFsmState.breakPaused;

  /// Advance countdown by [seconds] (test-friendly; UI can pass 1 each tick).
  void elapseSeconds(int seconds) {
    if (seconds <= 0) return;
    if (!_running) return;

    var left = seconds;
    while (left > 0 && _running) {
      if (_remainingSeconds > left) {
        _remainingSeconds -= left;
        left = 0;
      } else {
        final consumed = _remainingSeconds;
        _remainingSeconds = 0;
        left -= consumed;
        _onPhaseTimerReachedZero();
      }
    }
    _notify();
  }

  /// IDLE → focus running.
  bool tryStart() {
    if (_state != CozyFocusFsmState.idle) return false;
    _state = CozyFocusFsmState.focusRunning;
    _remainingSeconds = _config.workSeconds;
    _notify();
    return true;
  }

  bool tryPause() {
    if (_state == CozyFocusFsmState.focusRunning) {
      _state = CozyFocusFsmState.focusPaused;
      _notify();
      return true;
    }
    if (_state == CozyFocusFsmState.breakRunning) {
      _state = CozyFocusFsmState.breakPaused;
      _notify();
      return true;
    }
    return false;
  }

  bool tryResume() {
    if (_state == CozyFocusFsmState.focusPaused) {
      _state = CozyFocusFsmState.focusRunning;
      _notify();
      return true;
    }
    if (_state == CozyFocusFsmState.breakPaused) {
      _state = CozyFocusFsmState.breakRunning;
      _notify();
      return true;
    }
    return false;
  }

  /// SESSION_COMPLETE → IDLE; timers back to configured work length.
  bool tryFinish() {
    if (_state != CozyFocusFsmState.sessionComplete) return false;
    _state = CozyFocusFsmState.idle;
    _cumulativeFocusSeconds = 0;
    _remainingSeconds = _config.workSeconds;
    _notify();
    return true;
  }

  void _onPhaseTimerReachedZero() {
    switch (_state) {
      case CozyFocusFsmState.focusRunning:
        _completeFocusSlice();
        break;
      case CozyFocusFsmState.breakRunning:
        _completeBreakSlice();
        break;
      default:
        break;
    }
  }

  void _completeFocusSlice() {
    _cumulativeFocusSeconds += _config.workSeconds;
    final cap = _config.sessionCapSeconds;
    if (_cumulativeFocusSeconds >= cap) {
      _state = CozyFocusFsmState.sessionComplete;
      _remainingSeconds = 0;
      return;
    }
    onBreakChime?.call();
    _state = CozyFocusFsmState.breakRunning;
    _remainingSeconds = _config.breakSeconds;
  }

  void _completeBreakSlice() {
    _state = CozyFocusFsmState.focusRunning;
    _remainingSeconds = _config.workSeconds;
    if (kPlayGong) {
      onWorkGong?.call();
    }
  }

  void _notify() {
    notifyListeners();
    if (!_snapshotController.isClosed) {
      _snapshotController.add(snapshot);
    }
  }

  static String _phaseLabelFor(CozyFocusFsmState s) {
    switch (s) {
      case CozyFocusFsmState.idle:
      case CozyFocusFsmState.focusRunning:
      case CozyFocusFsmState.focusPaused:
        return 'FOCUS SESSION';
      case CozyFocusFsmState.breakRunning:
      case CozyFocusFsmState.breakPaused:
        return 'REST SESSION';
      case CozyFocusFsmState.sessionComplete:
        return '(session ended)';
    }
  }

  @override
  void dispose() {
    _snapshotController.close();
    super.dispose();
  }
}
