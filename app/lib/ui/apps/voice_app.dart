import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../../theme.dart';
import '../widgets.dart';

const _recOrange = Color(0xFFFF7A45);

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Gravador',
      titleWidget: Row(children: [
        Icon(Icons.mic, color: _recOrange),
        const SizedBox(width: 8),
        Text('Gravador',
            style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const _Clip('Áudio pra vó', '0:12', 'voz normal'),
          const _Clip('Descrição do apê — Vila Olímpia', '0:48', 'voz normal'),
          const _Clip('Lembrete DARF', '0:06', 'voz normal'),
          const _Clip('Lista de mercado falada', '0:22', 'voz normal'),
          const _Clip('Recado pro Jorge', '0:15', 'voz normal'),
          const _Clip('Cantarolando música', '0:31', 'voz normal'),
          const _Clip('Áudio pra pelada', '0:09', 'voz normal'),
          const Divider(height: 28),
          Row(children: [
            Icon(Icons.delete_outline, size: 16, color: AppTheme.textDim),
            const SizedBox(width: 6),
            Text('LIXEIRA',
                style: TextStyle(
                    color: AppTheme.textDim,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          if (g.audioRecoverable)
            const _Recovered()
          else
            LockedBanner(
                text:
                    'Tem um áudio apagado aqui. Você só vai pensar em recuperar a '
                    'voz dele depois de enxergar o padrão das viagens.'),
        ],
      ),
    );
  }
}

class _Clip extends StatelessWidget {
  const _Clip(this.title, this.dur, this.note);
  final String title, dur, note;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(Icons.play_circle_fill, color: _recOrange, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppTheme.text)),
              Text('$dur · $note',
                  style: TextStyle(color: AppTheme.textDim, fontSize: 12)),
            ],
          ),
        ),
      ]),
    );
  }
}

class _Recovered extends StatefulWidget {
  const _Recovered();
  @override
  State<_Recovered> createState() => _RecoveredState();
}

class _RecoveredState extends State<_Recovered>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 4));
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text('voz_05.m4a — recuperado',
                  style: TextStyle(
                      color: AppTheme.text, fontWeight: FontWeight.w700)),
            ),
            PinButton(evidenceId: 'audio_recovered'),
          ]),
          Row(children: [
            GestureDetector(
              onTap: () => _c.forward(from: 0),
              child: Icon(Icons.play_circle_fill,
                  color: AppTheme.accent, size: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 34,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (_, _) => CustomPaint(painter: _Wave(_c.value)),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            '"…fica tranquila, eu te busco na rodoviária, fica no portão 3…" — a '
            'voz não é a dele. Outro sotaque, gíria de praia. É o "Theo".',
            style: TextStyle(color: AppTheme.text, fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _Wave extends CustomPainter {
  _Wave(this.t);
  final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    const bars = 30;
    final rnd = Random(7);
    for (var i = 0; i < bars; i++) {
      final x = i / bars * size.width;
      final lit = (i / bars) <= t;
      final h = (0.2 + rnd.nextDouble() * 0.8) * size.height;
      paint.color =
          lit ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.25);
      canvas.drawLine(Offset(x, (size.height - h) / 2),
          Offset(x, (size.height + h) / 2), paint);
    }
  }

  @override
  bool shouldRepaint(_Wave old) => old.t != t;
}
