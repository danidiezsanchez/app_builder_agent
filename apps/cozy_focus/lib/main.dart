import 'package:flutter/material.dart';

void main() {
  runApp(const CozyFocusApp());
}

/// D0 shell only: proves Flutter project + theme wiring. FSM/timer in later tasks.
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
      home: const _CozyShell(),
    );
  }
}

class _CozyShell extends StatelessWidget {
  const _CozyShell();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Cozy Focus'),
        backgroundColor: scheme.surfaceContainerHighest,
      ),
      body: Center(
        child: Text(
          'Shell ready — timer & FSM next.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
