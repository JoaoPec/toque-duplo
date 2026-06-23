import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../theme.dart';

/// "O briefing" — Aline hands you the phone. Sets tone before the lock screen.
class BriefingScreen extends StatelessWidget {
  const BriefingScreen({super.key});

  static const _briefing = [
    'O celular chega até você dentro de um saco plástico de mercado, ainda com '
        'a etiqueta da feira da Benedito Calixto grudada no fundo. Quem entrega '
        'é Aline. Ela não senta. Fica de pé, mexendo na alça da bolsa, olhando '
        'pra porta como se Rafael fosse entrar a qualquer momento.',
    '"Eu não quero que você prove que ele é bom", ela fala. "Eu já sei como ele '
        'é bom. Ele é bom demais. Manda áudio de bom dia, lembra do meu remédio, '
        'almoça com a avó todo domingo."',
    'Ela respira. "Eu quero que você prove o resto."',
    'O resto, pra Aline, é uma mulher. Um nome no celular. Um fim de semana que '
        'não fecha. Ela acha que está te contratando pra confirmar uma traição.',
    'Você liga o aparelho. A bateria marca 87%, e caindo. Vê a tela de bloqueio: '
        'os dois em Maresias, sorrindo, o mar atrás. Parece o namorado mais '
        'tranquilo de São Paulo.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOQUE DUPLO',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'um caso de investigação',
                style: TextStyle(color: AppTheme.accent, letterSpacing: 2),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _briefing.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (_, i) => Text(
                    _briefing[i],
                    style: TextStyle(
                      color: i == 2 ? AppTheme.text : AppTheme.textDim,
                      height: 1.5,
                      fontSize: 15,
                      fontStyle: i == 2 ? FontStyle.italic : FontStyle.normal,
                      fontWeight: i == 2 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => context.read<GameState>().startGame(),
                  child: const Text(
                    'PEGAR O CELULAR',
                    style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
