import 'dart:ui';

import 'package:cozy_focus/cozy_focus.dart';
import 'package:flutter/material.dart';

/// D4 “Set your flow”: scrim + blur, three sliders, CLOSE vs confirm.
///
/// Confirm returns a new [CozyFocusConfig] (clamped). CLOSE / backdrop tap
/// returns `null`. Applies **immediately on confirm** only while the engine
/// is idle (caller must enforce opening from idle).
Future<CozyFocusConfig?> showSetFlowModal(
  BuildContext context, {
  required CozyFocusConfig initial,
}) {
  return showDialog<CozyFocusConfig?>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (ctx) {
      return _SetFlowDialog(initial: CozyFocusFlowPrefs.clampConfig(initial));
    },
  );
}

class _SetFlowDialog extends StatefulWidget {
  const _SetFlowDialog({required this.initial});

  final CozyFocusConfig initial;

  @override
  State<_SetFlowDialog> createState() => _SetFlowDialogState();
}

class _SetFlowDialogState extends State<_SetFlowDialog> {
  late int _work;
  late int _breakM;
  late double _capHours;

  @override
  void initState() {
    super.initState();
    _work = widget.initial.workMinutes;
    _breakM = widget.initial.breakMinutes;
    _capHours = widget.initial.sessionCapHours;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: mq.size.width,
        height: mq.size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.32),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Material(
                    color: scheme.surface,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Set your flow',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Work, break, and total focus cap apply after you confirm.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Work duration ($_work min)',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                            ),
                            child: Slider(
                              key: const Key('set_flow_work_slider'),
                              value: _work.toDouble(),
                              min: 5,
                              max: 60,
                              divisions: 55,
                              label: '$_work min',
                              onChanged: (v) => setState(() => _work = v.round()),
                            ),
                          ),
                          Text(
                            'Break ($_breakM min)',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(trackHeight: 3),
                            child: Slider(
                              key: const Key('set_flow_break_slider'),
                              value: _breakM.toDouble(),
                              min: 1,
                              max: 30,
                              divisions: 29,
                              label: '$_breakM min',
                              onChanged: (v) => setState(() => _breakM = v.round()),
                            ),
                          ),
                          Text(
                            'Session focus cap (${_capHours.toStringAsFixed(1)} h)',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(trackHeight: 3),
                            child: Slider(
                              key: const Key('set_flow_cap_slider'),
                              value: _capHours,
                              min: 0.5,
                              max: 8.0,
                              divisions: 15,
                              label: '${_capHours.toStringAsFixed(1)} h',
                              onChanged: (v) => setState(() => _capHours = v),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('CLOSE'),
                              ),
                              const Spacer(),
                              FilledButton.icon(
                                onPressed: () {
                                  final next = CozyFocusFlowPrefs.clampConfig(
                                    CozyFocusConfig(
                                      workMinutes: _work,
                                      breakMinutes: _breakM,
                                      sessionCapHours: _capHours,
                                    ),
                                  );
                                  Navigator.of(context).pop(next);
                                },
                                icon: const Icon(Icons.check, size: 20),
                                label: const Text('Confirm'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
