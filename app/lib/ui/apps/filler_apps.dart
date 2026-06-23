import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets.dart';

// ───────────────────────────────────────────────────────────────────────────
// Apps "de enfeite": funcionam, mas não têm nada pra investigação. Servem pra
// fazer o celular parecer um celular de verdade — e pra esconder os apps que
// importam no meio do resto.
// ───────────────────────────────────────────────────────────────────────────

/// Calculadora funcional, no visual do iOS.
class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _display = '0';
  double? _acc;
  String? _op;
  bool _fresh = true;

  void _input(String k) {
    setState(() {
      switch (k) {
        case 'AC':
          _display = '0';
          _acc = null;
          _op = null;
          _fresh = true;
        case '+/-':
          if (_display != '0') {
            _display = _display.startsWith('-')
                ? _display.substring(1)
                : '-$_display';
          }
        case '%':
          _display = _fmt((double.tryParse(_display) ?? 0) / 100);
        case '+':
        case '−':
        case '×':
        case '÷':
          _acc = double.tryParse(_display);
          _op = k;
          _fresh = true;
        case '=':
          final b = double.tryParse(_display) ?? 0;
          if (_acc != null && _op != null) {
            final a = _acc!;
            final r = switch (_op!) {
              '+' => a + b,
              '−' => a - b,
              '×' => a * b,
              '÷' => b == 0 ? double.nan : a / b,
              _ => b,
            };
            _display = r.isNaN ? 'Erro' : _fmt(r);
            _acc = null;
            _op = null;
            _fresh = true;
          }
        case '.':
          if (_fresh) {
            _display = '0.';
            _fresh = false;
          } else if (!_display.contains('.')) {
            _display += '.';
          }
        default: // dígitos
          if (_fresh || _display == '0') {
            _display = k;
            _fresh = false;
          } else if (_display.length < 9) {
            _display += k;
          }
      }
    });
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(4).replaceFirst(RegExp(r'0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9500);
    const grey = Color(0xFF333333);
    const lightGrey = Color(0xFFA5A5A5);
    final rows = [
      [('AC', lightGrey, Colors.black), ('+/-', lightGrey, Colors.black),
        ('%', lightGrey, Colors.black), ('÷', orange, Colors.white)],
      [('7', grey, Colors.white), ('8', grey, Colors.white),
        ('9', grey, Colors.white), ('×', orange, Colors.white)],
      [('4', grey, Colors.white), ('5', grey, Colors.white),
        ('6', grey, Colors.white), ('−', orange, Colors.white)],
      [('1', grey, Colors.white), ('2', grey, Colors.white),
        ('3', grey, Colors.white), ('+', orange, Colors.white)],
      [('0', grey, Colors.white), ('.', grey, Colors.white),
        ('=', orange, Colors.white)],
    ];
    return AppShell(
      headerColor: Colors.black,
      headerFg: Colors.white,
      title: 'Calculadora',
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: FittedBox(
                  child: Text(_display,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.w300)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          for (final b in row)
                            _Key(
                              label: b.$1,
                              bg: b.$2,
                              fg: b.$3,
                              wide: b.$1 == '0',
                              onTap: () => _input(b.$1),
                            ),
                        ],
                      ),
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

class _Key extends StatelessWidget {
  const _Key(
      {required this.label,
      required this.bg,
      required this.fg,
      required this.onTap,
      this.wide = false});
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  final bool wide;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: wide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: AspectRatio(
          aspectRatio: wide ? 2.1 : 1,
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: onTap,
              child: Center(
                child: Text(label,
                    style: TextStyle(
                        color: fg, fontSize: 28, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tempo (clima) — São Paulo, estático e decorativo.
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: const Color(0xFF1B3A5B),
      headerFg: Colors.white,
      title: 'Tempo',
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2B5C8A), Color(0xFF14202B)]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Column(
                children: [
                  Text('São Paulo',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                  Text('18°',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 84,
                          fontWeight: FontWeight.w200)),
                  Text('Chuvisco · Máx 21° Mín 14°',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            for (final h in [
              ('Agora', Icons.grain, '18°'),
              ('00h', Icons.nights_stay, '16°'),
              ('03h', Icons.water_drop, '15°'),
              ('06h', Icons.cloud, '14°'),
              ('09h', Icons.wb_cloudy, '17°'),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                        width: 60,
                        child: Text(h.$1,
                            style: const TextStyle(color: Colors.white))),
                    Icon(h.$2, color: Colors.white70, size: 20),
                    const Spacer(),
                    Text(h.$3, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Center(
              child: Text('Fim de semana com pancadas no Litoral Norte.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Relógio — mostra a hora "do celular" (diegética). Decorativo.
class ClockApp extends StatelessWidget {
  const ClockApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: Colors.black,
      headerFg: Colors.white,
      title: 'Relógio',
      body: Container(
        color: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text('23:30',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w200)),
            ),
            const Center(
              child: Text('São Paulo · hoje',
                  style: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 30),
            for (final c in [
              ('Tóquio', '+12h', '11:30'),
              ('Maresias', '0h', '23:30'),
              ('Trancoso', '0h', '23:30'),
            ])
              ListTile(
                title: Text(c.$1, style: const TextStyle(color: Colors.white)),
                subtitle: Text(c.$2,
                    style: const TextStyle(color: Colors.white54)),
                trailing: Text(c.$3,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.w200)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Ajustes — lista no estilo iOS. Decorativo (com um respiro de humor sombrio).
class SettingsApp extends StatelessWidget {
  const SettingsApp({super.key});
  @override
  Widget build(BuildContext context) {
    const tiles = [
      (Icons.airplanemode_active, 'Modo avião', Color(0xFFFF9500)),
      (Icons.wifi, 'Wi-Fi', Color(0xFF007AFF)),
      (Icons.bluetooth, 'Bluetooth', Color(0xFF007AFF)),
      (Icons.notifications, 'Notificações', Color(0xFFFF3B30)),
      (Icons.lock, 'Privacidade e Segurança', Color(0xFF007AFF)),
      (Icons.battery_full, 'Bateria', Color(0xFF34C759)),
    ];
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Ajustes',
      body: Container(
        color: const Color(0xFF000000),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            for (final t in tiles)
              ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: t.$3, borderRadius: BorderRadius.circular(7)),
                  child: Icon(t.$1, color: Colors.white, size: 18),
                ),
                title: Text(t.$2, style: TextStyle(color: AppTheme.text)),
                trailing: Icon(Icons.chevron_right, color: AppTheme.textDim),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                  'Bateria em modo de economia indisponível: a bateria está '
                  'baixa e caindo.',
                  style:
                      TextStyle(color: AppTheme.textDim, fontSize: 12, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder pros ícones puramente decorativos (Câmera, Música, etc.).
class StubApp extends StatelessWidget {
  const StubApp(
      {super.key, required this.title, required this.icon, required this.note});
  final String title;
  final IconData icon;
  final String note;
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: title,
      body: Container(
        color: AppTheme.bg,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: AppTheme.textDim),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(note,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.textDim, fontSize: 14, height: 1.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
