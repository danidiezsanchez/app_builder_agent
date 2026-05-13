import 'package:cozy_focus/cozy_focus.dart';
import 'package:cozy_focus/ui/cozy_focus_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final initial = CozyFocusFlowPrefs.load(prefs) ?? CozyFocusConfig.demoDefault;
  runApp(CozyFocusApp(initialSessionConfig: initial));
}

/// Cozy Focus shell + D3 main session UI (FSM in `package:cozy_focus/cozy_focus.dart`).
class CozyFocusApp extends StatelessWidget {
  const CozyFocusApp({super.key, required this.initialSessionConfig});

  final CozyFocusConfig initialSessionConfig;

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
      home: CozyFocusSessionScreen(initialConfig: initialSessionConfig),
    );
  }
}
