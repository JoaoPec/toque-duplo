import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_state.dart';
import '../theme.dart';
import 'apps/bank_app.dart';
import 'apps/browser_app.dart';
import 'apps/calendar_app.dart';
import 'apps/dating_app.dart';
import 'apps/filler_apps.dart';
import 'apps/gallery_app.dart';
import 'apps/messages_app.dart';
import 'apps/notes_app.dart';
import 'apps/ride_app.dart';
import 'apps/voice_app.dart';
import 'dossier_screen.dart';

/// The phone: a persistent status bar (battery = the clock) over a nested
/// navigator holding the lock screen, the home grid, and each app.
class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const StatusBar(),
            Expanded(
              child: Navigator(
                onGenerateRoute: (s) => MaterialPageRoute(
                    builder: (_) => const HomeScreen(), settings: s),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    final battery = context.select((GameState g) => g.battery);
    final low = battery <= 25;
    final color = low ? AppTheme.accent : AppTheme.text;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
      child: Row(
        children: [
          Text('VIVO  •  4G',
              style: TextStyle(color: AppTheme.textDim, fontSize: 11)),
          const Spacer(),
          Text('23:${(59 - (battery ~/ 2)).clamp(0, 59).toString().padLeft(2, '0')}',
              style: TextStyle(
                  color: AppTheme.textDim,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('${battery.round()}%',
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 5),
          _BatteryGlyph(level: battery / 100, low: low),
        ],
      ),
    );
  }
}

class _BatteryGlyph extends StatelessWidget {
  const _BatteryGlyph({required this.level, required this.low});
  final double level;
  final bool low;
  @override
  Widget build(BuildContext context) {
    final color = low ? AppTheme.accent : AppTheme.good;
    return SizedBox(
      width: 26,
      height: 13,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.textDim, width: 1.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: level.clamp(0.04, 1),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(1.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _locked = true;
  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return _LockScreen(onUnlock: () => setState(() => _locked = false));
    }
    return const _AppGrid();
  }
}

/// A notification preview on the lock screen.
class _Notif {
  const _Notif(this.app, this.icon, this.color, this.title, this.body, this.when);
  final String app;
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String when;
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});
  final VoidCallback onUnlock;

  static const _notifs = [
    _Notif('TELEFONE', Icons.phone_missed, Color(0xFF34C759),
        'Chamada perdida (2)', 'Aline ❤️', 'agora'),
    _Notif('WHATSAPP', Icons.chat, Color(0xFF25D366), 'Aline ❤️',
        'tô em reunião amor, te ligo depois', '23:16'),
    _Notif('WHATSAPP', Icons.chat, Color(0xFF25D366), 'Almoço de Domingo 🍱',
        'Vó: tira esses óculos de mentira menino 🤣', '23:02'),
    _Notif('TINDER', Icons.local_fire_department, Color(0xFFFE3C72),
        'Você tem 1 nova mensagem 🔥', 'Letícia · Pinheiros', '22:48'),
    _Notif('WHATSAPP', Icons.chat, Color(0xFF25D366), 'Pelada de Quinta ⚽',
        '12 novas mensagens', '21:30'),
    _Notif('NUBANK', Icons.account_balance_wallet, Color(0xFF820AD1),
        'Compra aprovada', 'Floricultura Flor & Cia — R\$ 95,00', '20:10'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onUnlock,
      onVerticalDragEnd: (_) => onUnlock(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B2A33), Color(0xFF11161C), Color(0xFF0B0D10)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 28),
            Icon(Icons.lock, size: 18, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            const Text('sexta-feira, 13 de junho',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
            const Text('23:16',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 78,
                    fontWeight: FontWeight.w200,
                    height: 1.1)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final n in _notifs) _NotifCard(n: n),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_up,
                color: Colors.white.withValues(alpha: 0.6)),
            Padding(
              padding: const EdgeInsets.only(bottom: 22, top: 2),
              child: Text('deslize pra investigar',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.n});
  final _Notif n;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: n.color, borderRadius: BorderRadius.circular(8)),
            child: Icon(n.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(n.app,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w700)),
                    ),
                    Text(n.when,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(n.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(n.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneApp {
  const PhoneApp(this.label, this.icon, this.gradient, this.builder,
      {this.badge});
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final WidgetBuilder builder;
  final int Function(GameState)? badge; // iOS-style red notification badge
}

class _AppGrid extends StatelessWidget {
  const _AppGrid();

  static final apps = <PhoneApp>[
    PhoneApp('WhatsApp', Icons.chat, const [Color(0xFF25D366), Color(0xFF0E8C4F)],
        (_) => const MessagesApp(),
        badge: (g) => g.unreadWhatsapp),
    PhoneApp('Tinder', Icons.local_fire_department,
        const [Color(0xFFFD297B), Color(0xFFFF655B)], (_) => const DatingApp()),
    PhoneApp('Fotos', Icons.photo,
        const [Color(0xFFFFFFFF), Color(0xFFE6E6E6)], (_) => const GalleryApp()),
    PhoneApp('Câmera', Icons.camera_alt,
        const [Color(0xFF3A3A3C), Color(0xFF1C1C1E)],
        (_) => const StubApp(
            title: 'Câmera',
            icon: Icons.camera_alt,
            note: 'Rolo vazio. As fotos que importam não estão aqui — estão '
                'guardadas no app Fotos.')),
    PhoneApp('Chrome', Icons.public,
        const [Color(0xFF4285F4), Color(0xFF1A73E8)], (_) => const BrowserApp()),
    PhoneApp('Notas', Icons.sticky_note_2,
        const [Color(0xFFFFE57F), Color(0xFFFFC400)], (_) => const NotesApp()),
    PhoneApp('Agenda', Icons.event,
        const [Color(0xFFFFFFFF), Color(0xFFE6E6E6)], (_) => const CalendarApp()),
    PhoneApp('Tempo', Icons.cloud,
        const [Color(0xFF4A90D9), Color(0xFF1B3A5B)], (_) => const WeatherApp()),
    PhoneApp('Nubank', Icons.account_balance_wallet,
        const [Color(0xFF9B27D6), Color(0xFF6A0DAD)], (_) => const BankApp()),
    PhoneApp('99', Icons.local_taxi,
        const [Color(0xFFFFE000), Color(0xFFFFC400)], (_) => const RideApp()),
    PhoneApp('Calculadora', Icons.calculate,
        const [Color(0xFF505050), Color(0xFF1C1C1E)],
        (_) => const CalculatorApp()),
    PhoneApp('Relógio', Icons.access_time,
        const [Color(0xFF1C1C1E), Color(0xFF000000)], (_) => const ClockApp()),
    PhoneApp('Música', Icons.music_note,
        const [Color(0xFFFB5C74), Color(0xFFF93A5A)],
        (_) => const StubApp(
            title: 'Música',
            icon: Icons.music_note,
            note: 'Playlists de academia e de praia. Nada que ajude no caso.')),
    PhoneApp('Ajustes', Icons.settings,
        const [Color(0xFFADADAD), Color(0xFF7B7B7B)], (_) => const SettingsApp()),
    PhoneApp('Gravador', Icons.mic,
        const [Color(0xFFFF8A3D), Color(0xFFEF5E1A)], (_) => const VoiceApp()),
    PhoneApp('Dossiê', Icons.fact_check,
        const [Color(0xFFE5484D), Color(0xFFA31419)],
        (_) => const DossierScreen(),
        badge: (g) => g.pinned.length),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF24344D), Color(0xFF161726), Color(0xFF0B0D10)],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
              crossAxisCount: 4,
              mainAxisSpacing: 18,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
              children: [for (final app in apps) _AppIcon(app: app)],
            ),
          ),
          // Page dots (decorativos, estilo iOS).
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.35),
                        shape: BoxShape.circle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.app});
  final PhoneApp app;
  @override
  Widget build(BuildContext context) {
    final count = app.badge?.call(context.watch<GameState>()) ?? 0;
    // White/light icon glyphs except on light-colored tiles.
    final lightTile = app.gradient.first.computeLuminance() > 0.6;
    final glyphColor = lightTile ? const Color(0xFF1C1C1E) : Colors.white;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: app.builder)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: app.gradient),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 6,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: Icon(app.icon, color: glyphColor, size: 30),
              ),
              if (count > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    constraints:
                        const BoxConstraints(minWidth: 20, minHeight: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF161726), width: 1.5),
                    ),
                    child: Center(
                      child: Text('$count',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(app.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 3),
                  ]),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
