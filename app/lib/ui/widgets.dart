import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../theme.dart';

/// A phone-app shell: a per-app coloured header (so each app can look like the
/// real thing) over a scrollable body, with a system back arrow.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.headerColor,
    required this.headerFg,
    required this.title,
    required this.body,
    this.titleWidget,
    this.actions,
  });

  final Color headerColor;
  final Color headerFg;
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: Column(
        children: [
          Material(
            color: headerColor,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: headerFg),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: titleWidget ??
                          Text(title,
                              style: TextStyle(
                                  color: headerFg,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                    ),
                    ...?actions,
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Bookmark toggle that pins a fragment to the corkboard. It deliberately does
/// NOT signal whether the fragment matters — every notable item has one.
class PinButton extends StatelessWidget {
  const PinButton({super.key, required this.evidenceId, this.dense = false});
  final String evidenceId;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final available = g.evidenceAvailable(evidenceId);
    final pinned = g.isPinned(evidenceId);
    return IconButton(
      visualDensity: dense ? VisualDensity.compact : null,
      tooltip: pinned ? 'Remover do dossiê' : 'Marcar como prova',
      icon: Icon(
        pinned ? Icons.push_pin : Icons.push_pin_outlined,
        size: dense ? 18 : 22,
        color: !available
            ? AppTheme.textDim.withValues(alpha: 0.4)
            : pinned
                ? AppTheme.accent
                : AppTheme.textDim,
      ),
      onPressed: !available
          ? null
          : () {
              HapticFeedback.selectionClick();
              g.togglePin(evidenceId);
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 1100),
                  backgroundColor: AppTheme.surfaceHi,
                  content: Text(
                    g.isPinned(evidenceId)
                        ? 'Fixado no dossiê'
                        : 'Removido do dossiê',
                    style: TextStyle(color: AppTheme.text),
                  ),
                ));
            },
    );
  }
}

/// Wraps a list item with a long-press-to-pin gesture + an inline PinButton.
class Pinnable extends StatelessWidget {
  const Pinnable({super.key, required this.evidenceId, required this.child});
  final String evidenceId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final pinned = g.isPinned(evidenceId);
    return GestureDetector(
      onLongPress: g.evidenceAvailable(evidenceId)
          ? () => g.togglePin(evidenceId)
          : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: pinned ? AppTheme.accent : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            PinButton(evidenceId: evidenceId, dense: true),
          ],
        ),
      ),
    );
  }
}

class LockedBanner extends StatelessWidget {
  const LockedBanner({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: AppTheme.textDim, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: AppTheme.textDim, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

/// Source → header colour, so corkboard chips and labels can echo each app.
Color sourceColor(String source) => switch (source) {
      'WhatsApp' => const Color(0xFF25D366),
      'Tinder' => const Color(0xFFFE3C72),
      'Fotos' => const Color(0xFFEA4335),
      'Tinder ' => const Color(0xFFFE3C72),
      'Notas' => const Color(0xFFFFC400),
      'Agenda' => const Color(0xFFEA4335),
      'Chrome' => const Color(0xFF4285F4),
      'Nubank' => const Color(0xFF820AD1),
      'Gravador' => const Color(0xFFFF7A45),
      _ => AppTheme.textDim,
    };
