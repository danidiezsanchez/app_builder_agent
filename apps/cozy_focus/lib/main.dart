import 'package:cozy_focus/ui/cozy_focus_session_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CozyFocusApp());
}

/// Cozy Focus shell + D3 main session UI (FSM in `package:cozy_focus/cozy_focus.dart`).
class CozyFocusApp extends StatelessWidget {
  const CozyFocusApp({super.key});

  static ThemeData _buildLightTheme() {
    const seed = Color(0xFF8B5A3C);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy Focus',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      home: const CozyFocusSessionScreen(),
    );
  }
}
