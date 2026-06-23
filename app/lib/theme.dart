import 'package:flutter/material.dart';

/// Visual identity for Toque Duplo — a dark, urban "seized phone" aesthetic.
/// Cold graphite chrome with a single warm-red accent for "evidence" moments.
class AppTheme {
  static const Color bg = Color(0xFF0B0D10);
  static const Color surface = Color(0xFF15181D);
  static const Color surfaceHi = Color(0xFF1E232A);
  static const Color line = Color(0xFF2A313A);
  static const Color text = Color(0xFFE7ECF1);
  static const Color textDim = Color(0xFF8A94A0);
  static const Color accent = Color(0xFFE5484D); // evidence red
  static const Color good = Color(0xFF3DD68C);
  static const Color tinder = Color(0xFFFE3C72);
  static const Color whats = Color(0xFF25D366);

  static ThemeData build() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: base.colorScheme.copyWith(
        primary: accent,
        secondary: good,
        surface: surface,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: text,
        displayColor: text,
        fontFamily: 'Roboto',
      ),
      dividerColor: line,
    );
  }
}
