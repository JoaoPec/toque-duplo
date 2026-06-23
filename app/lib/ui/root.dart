import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import 'briefing_screen.dart';
import 'ending_screen.dart';
import 'phone_shell.dart';

/// Switches between the major game phases. App is mobile-only, so each phase
/// fills the whole screen — the device *is* the phone.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = context.select((GameState g) => g.phase);
    return Scaffold(
      body: switch (phase) {
        GamePhase.briefing => const BriefingScreen(),
        GamePhase.playing => const PhoneShell(),
        GamePhase.solved => const EndingScreen(good: true),
        GamePhase.failed => const EndingScreen(good: false),
      },
    );
  }
}
