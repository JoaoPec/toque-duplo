import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/deduction.dart';
import '../game/evidence.dart';
import '../game/game_state.dart';
import '../theme.dart';

class EndingScreen extends StatelessWidget {
  const EndingScreen({super.key, required this.good});
  final bool good;

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final color = good ? AppTheme.good : AppTheme.accent;
    final mins = g.elapsed.inMinutes;
    final secs = g.elapsed.inSeconds % 60;
    final tempo = '${mins}m ${secs.toString().padLeft(2, '0')}s';
    return Container(
      color: AppTheme.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Icon(good ? Icons.shield_moon : Icons.report,
                        color: color, size: 72),
                    const SizedBox(height: 20),
                    Text(good ? 'DESMASCARADO' : 'TEMPO ESGOTADO',
                        style: TextStyle(
                            color: color,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2)),
                    const SizedBox(height: 16),
                    Text(good ? _goodText : _badText,
                        style: TextStyle(
                            color: AppTheme.text, fontSize: 15, height: 1.55)),
                    const SizedBox(height: 20),
                    _StatsCard(
                      color: color,
                      rows: [
                        ('Tempo de investigação', tempo),
                        ('Provas fixadas', '${g.pinned.length} de ${Ev.all.length}'),
                        ('Conexões feitas',
                            '${g.deductionCount} de ${Deductions.all.length}'),
                        ('Dicas usadas', '${g.totalHintsUsed}'),
                        ('Bateria restante', '${g.battery.round()}%'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => context.read<GameState>().restart(),
                  child: Text(good ? 'INVESTIGAR DE NOVO' : 'OLHAR MAIS FUNDO',
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _goodText =
      'Você cruzou a Letícia, o café marcado em Pinheiros e o padrão das viagens '
      'e mandou tudo a tempo. Rafael é abordado antes do quarto encontro.\n\n'
      'Aline aparece dois dias depois — estava na casa da mãe em Sorocaba, viva, '
      'com medo. O neto educado do seu Andrade vira manchete. E uma mulher de 23 '
      'anos em Pinheiros nunca vai saber o quão perto chegou.';

  static const _badText =
      'A bateria morreu na sua mão. Você gastou tempo demais na Marina, na '
      'traição banal que estava na superfície — quase pedindo pra ser achada.\n\n'
      'Dias depois, mais uma notícia: "Jovem some após encontro marcado por '
      'aplicativo. Pinheiros." Você tinha tudo. Só não olhou fundo o bastante, '
      'a tempo.';
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.color, required this.rows});
  final Color color;
  final List<(String, String)> rows;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        children: [
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Text(r.$1,
                        style: TextStyle(
                            color: AppTheme.textDim, fontSize: 13.5)),
                  ),
                  Text(r.$2,
                      style: TextStyle(
                          color: AppTheme.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
