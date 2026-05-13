import 'package:cozy_focus/session/cozy_focus_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for [CozyFocusConfig] persisted by the D4 Set modal.
class CozyFocusFlowPrefs {
  CozyFocusFlowPrefs._();

  static const _kWork = 'cozy_focus_work_minutes';
  static const _kBreak = 'cozy_focus_break_minutes';
  static const _kCap = 'cozy_focus_session_cap_hours';

  /// Returns `null` if nothing stored yet or data is invalid.
  static CozyFocusConfig? load(SharedPreferences prefs) {
    final work = prefs.getInt(_kWork);
    final br = prefs.getInt(_kBreak);
    final cap = prefs.getDouble(_kCap);
    if (work == null || br == null || cap == null) return null;
    try {
      return clampConfig(
        CozyFocusConfig(
          workMinutes: work,
          breakMinutes: br,
          sessionCapHours: cap,
        ),
      );
    } on AssertionError {
      return null;
    }
  }

  /// Clamps to demo-build ranges before save (same as the Set modal).
  static Future<void> save(SharedPreferences prefs, CozyFocusConfig config) async {
    final c = clampConfig(config);
    await prefs.setInt(_kWork, c.workMinutes);
    await prefs.setInt(_kBreak, c.breakMinutes);
    await prefs.setDouble(_kCap, c.sessionCapHours);
  }

  static CozyFocusConfig clampConfig(CozyFocusConfig c) {
    return CozyFocusConfig(
      workMinutes: c.workMinutes.clamp(5, 60),
      breakMinutes: c.breakMinutes.clamp(1, 30),
      sessionCapHours: c.sessionCapHours.clamp(0.5, 8.0).toDouble(),
    );
  }
}
