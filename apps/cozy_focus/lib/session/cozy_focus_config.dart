import 'package:flutter/foundation.dart';

/// Flow settings (Set modal will persist these in D4).
@immutable
class CozyFocusConfig {
  const CozyFocusConfig({
    required this.workMinutes,
    required this.breakMinutes,
    required this.sessionCapHours,
  })  : assert(workMinutes >= 1),
        assert(breakMinutes >= 1),
        assert(sessionCapHours > 0);

  /// Defaults from COZY_FOCUS.md (work 25, break 5, total 2 h).
  static const CozyFocusConfig demoDefault = CozyFocusConfig(
    workMinutes: 25,
    breakMinutes: 5,
    sessionCapHours: 2.0,
  );

  final int workMinutes;
  final int breakMinutes;
  final double sessionCapHours;

  int get workSeconds => workMinutes * 60;
  int get breakSeconds => breakMinutes * 60;

  /// Total session ceiling as summed focus time (seconds).
  int get sessionCapSeconds => (sessionCapHours * 3600).round();

  CozyFocusConfig copyWith({
    int? workMinutes,
    int? breakMinutes,
    double? sessionCapHours,
  }) {
    return CozyFocusConfig(
      workMinutes: workMinutes ?? this.workMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      sessionCapHours: sessionCapHours ?? this.sessionCapHours,
    );
  }
}
