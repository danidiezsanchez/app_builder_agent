/// Explicit FSM states — no parallel booleans for “running”.
///
/// COZY_FOCUS.md names: IDLE, FOCUS_RUNNING, FOCUS_PAUSED, BREAK_RUNNING,
/// BREAK_PAUSED, SESSION_COMPLETE (Dart style uses lowerCamelCase values).
enum CozyFocusFsmState {
  idle,
  focusRunning,
  focusPaused,
  breakRunning,
  breakPaused,
  sessionComplete,
}
