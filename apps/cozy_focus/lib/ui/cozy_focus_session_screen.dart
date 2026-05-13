import 'dart:async';

import 'package:cozy_focus/cozy_focus.dart';
import 'package:cozy_focus/ui/set_flow_modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// D3 main view: timer, phase label, FSM actions, placeholder theme (TH01).
///
/// Solid-color stand-in until D1 pixel backgrounds exist (`demo-build` D1a).
class CozyFocusSessionScreen extends StatefulWidget {
  const CozyFocusSessionScreen({super.key, required this.initialConfig});

  /// Loaded in [main] from [CozyFocusFlowPrefs] (or [CozyFocusConfig.demoDefault]).
  final CozyFocusConfig initialConfig;

  @override
  State<CozyFocusSessionScreen> createState() => _CozyFocusSessionScreenState();
}

class _CozyFocusSessionScreenState extends State<CozyFocusSessionScreen> {
  late final CozyFocusSessionEngine _engine;
  Timer? _tick;
  bool _soundOn = true;

  static const _demoThemeId = 'TH01';

  @override
  void initState() {
    super.initState();
    _engine = CozyFocusSessionEngine(config: widget.initialConfig);
    _engine.addListener(_onEngine);
    _syncTicker();
  }

  void _onEngine() {
    if (mounted) setState(() {});
    _syncTicker();
  }

  void _syncTicker() {
    final running = _engine.state == CozyFocusFsmState.focusRunning ||
        _engine.state == CozyFocusFsmState.breakRunning;
    if (running) {
      _tick ??= Timer.periodic(const Duration(seconds: 1), (_) {
        _engine.elapseSeconds(1);
      });
    } else {
      _tick?.cancel();
      _tick = null;
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    _engine.removeListener(_onEngine);
    _engine.dispose();
    super.dispose();
  }

  String _mmss(int totalSeconds) {
    final safe = totalSeconds.clamp(0, 24 * 3600);
    final m = safe ~/ 60;
    final s = safe % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _primaryLabel() {
    switch (_engine.state) {
      case CozyFocusFsmState.idle:
        return 'START';
      case CozyFocusFsmState.focusRunning:
      case CozyFocusFsmState.breakRunning:
        return 'PAUSE';
      case CozyFocusFsmState.focusPaused:
      case CozyFocusFsmState.breakPaused:
        return 'RESUME';
      case CozyFocusFsmState.sessionComplete:
        return 'FINISH';
    }
  }

  void _onPrimary() {
    switch (_engine.state) {
      case CozyFocusFsmState.idle:
        _engine.tryStart();
        break;
      case CozyFocusFsmState.focusRunning:
      case CozyFocusFsmState.breakRunning:
        _engine.tryPause();
        break;
      case CozyFocusFsmState.focusPaused:
      case CozyFocusFsmState.breakPaused:
        _engine.tryResume();
        break;
      case CozyFocusFsmState.sessionComplete:
        _engine.tryFinish();
        break;
    }
  }

  Future<void> _onSet() async {
    if (_engine.state != CozyFocusFsmState.idle) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Open Set from idle — pause or finish this session first.'),
        ),
      );
      return;
    }
    final next = await showSetFlowModal(context, initial: _engine.config);
    if (next == null || !mounted) return;
    _engine.tryApplyConfig(next);
    final prefs = await SharedPreferences.getInstance();
    await CozyFocusFlowPrefs.save(prefs, next);
    if (mounted) setState(() {});
  }

  Future<void> _onSettings() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Theme list + mock IAP in D5.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final snap = _engine.snapshot;
    final timeText = _mmss(snap.remainingSeconds);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Cozy Focus'),
        backgroundColor: scheme.surfaceContainerHighest,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.primaryContainer.withValues(alpha: 0.55),
                      scheme.secondaryContainer.withValues(alpha: 0.45),
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _demoThemeId,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
                                letterSpacing: 1.2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PLACEHOLDER — replace with TH01 art (D1)',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          timeText,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontFeatures: const [FontFeature.tabularFigures()],
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          snap.phaseLabel,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                                letterSpacing: 0.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: _soundOn ? 'Mute (audio in D6)' : 'Unmute',
                        onPressed: () => setState(() => _soundOn = !_soundOn),
                        icon: Icon(_soundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _onPrimary,
                        child: Text(_primaryLabel()),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: _onSet, child: const Text('SET')),
                      const SizedBox(width: 24),
                      TextButton(onPressed: _onSettings, child: const Text('SETTINGS')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
