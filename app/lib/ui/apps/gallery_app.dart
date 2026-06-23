import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../../theme.dart';
import '../widgets.dart';

const _photosRed = Color(0xFFEA4335);

class _Pic {
  const _Pic(this.glyph, this.colors, {this.caption, this.evId, this.exif});
  final IconData glyph;
  final List<Color> colors;
  final String? caption;
  final String? evId;
  final String? exif;
}

const _visible = [
  _Pic(Icons.beach_access, [Color(0xFF36D1DC), Color(0xFF5B86E5)],
      caption: 'Praia', evId: 'album_beach', exif: 'Maresias · abril'),
  _Pic(Icons.apartment, [Color(0xFF8E9EAB), Color(0xFFEEF2F3)]),
  _Pic(Icons.outdoor_grill, [Color(0xFFF7971E), Color(0xFFFFD200)]),
  _Pic(Icons.ramen_dining, [Color(0xFFCB2D3E), Color(0xFFEF473A)]),
  _Pic(Icons.sailing, [Color(0xFF2193B0), Color(0xFF6DD5ED)]),
  _Pic(Icons.location_city, [Color(0xFF606C88), Color(0xFF3F4C6B)]),
];

const _hidden = [
  _Pic(Icons.face_retouching_natural, [Color(0xFF614385), Color(0xFF516395)],
      caption: 'perfil_3_gui.jpg',
      evId: 'glasses_selfie',
      exif: 'óculos de grau · regata · espelho de academia · Moema'),
  _Pic(Icons.surfing, [Color(0xFF2980B9), Color(0xFF6DD5FA)],
      caption: 'perfil_2_theo.jpg',
      evId: 'theo_selfie',
      exif: 'boné · barba postiça · prancha · Maresias'),
  _Pic(Icons.wb_twilight, [Color(0xFFFF512F), Color(0xFFF09819)],
      caption: 'IMG_0442.jpg',
      evId: 'geotag_maresias',
      exif: 'GPS: -23.79, -45.57 (Maresias) · 22/02 14:30'),
  _Pic(Icons.collections, [Color(0xFF232526), Color(0xFF414345)],
      caption: 'stories_salvos',
      evId: 'trophy_stories',
      exif: '3 prints: último story de Camila, Bia e Iasmin'),
];

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Fotos',
      titleWidget: Row(children: [
        const Icon(Icons.photo, color: _photosRed),
        const SizedBox(width: 8),
        Text('Fotos',
            style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ]),
      body: ListView(
        children: [
          _sectionLabel('Hoje · este mês'),
          _grid(_visible),
          const SizedBox(height: 8),
          _sectionLabel('Álbuns'),
          ListTile(
            leading: Icon(
                g.folderUnlocked ? Icons.folder_open : Icons.lock,
                color: g.caseOpen(2) ? _photosRed : AppTheme.textDim),
            title: Text('Documentos / Trabalho',
                style: TextStyle(color: AppTheme.text)),
            subtitle: Text(
                !g.caseOpen(2)
                    ? 'pasta protegida'
                    : g.folderUnlocked
                        ? '4 itens'
                        : 'protegida por PIN — toque para abrir',
                style: TextStyle(color: AppTheme.textDim, fontSize: 12)),
            onTap: !g.caseOpen(2)
                ? null
                : g.folderUnlocked
                    ? () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const _HiddenFolder()))
                    : () => _askPin(context),
          ),
          if (!g.caseOpen(2))
            LockedBanner(
                text:
                    'Você nem repara nessa pasta ainda. Algo precisa te fazer '
                    'desconfiar dela primeiro.'),
        ],
      ),
    );
  }

  Widget _sectionLabel(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
        child: Text(t,
            style: TextStyle(
                color: AppTheme.text,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
      );

  Widget _grid(List<_Pic> pics) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        children: [for (final p in pics) _Thumb(pic: p)],
      );

  void _askPin(BuildContext context) {
    showDialog(context: context, builder: (_) => const _PinDialog());
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.pic});
  final _Pic pic;
  @override
  Widget build(BuildContext context) {
    final pinned =
        pic.evId != null && context.watch<GameState>().isPinned(pic.evId!);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        builder: (_) => _PicSheet(pic: pic),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: pic.colors),
          border:
              pinned ? Border.all(color: AppTheme.accent, width: 2.5) : null,
        ),
        child: Stack(
          children: [
            Center(
                child: Icon(pic.glyph, color: Colors.white70, size: 34)),
            if (pinned)
              const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(Icons.push_pin,
                      color: AppTheme.accent, size: 16)),
          ],
        ),
      ),
    );
  }
}

class _PicSheet extends StatelessWidget {
  const _PicSheet({required this.pic});
  final _Pic pic;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: pic.colors),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Icon(pic.glyph, color: Colors.white70, size: 56)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pic.caption ?? 'IMG',
                        style: TextStyle(
                            color: AppTheme.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    if (pic.exif != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(pic.exif!,
                            style: TextStyle(
                                color: AppTheme.textDim,
                                fontSize: 13,
                                height: 1.4)),
                      ),
                  ],
                ),
              ),
              if (pic.evId != null) PinButton(evidenceId: pic.evId!),
            ],
          ),
        ],
      ),
    );
  }
}

class _HiddenFolder extends StatelessWidget {
  const _HiddenFolder();
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Documentos / Trabalho',
      body: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        padding: const EdgeInsets.all(3),
        children: [for (final p in _hidden) _Thumb(pic: p)],
      ),
    );
  }
}

class _PinDialog extends StatefulWidget {
  const _PinDialog();
  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  String _pin = '';
  bool _error = false;

  void _tap(String d) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length == 4) {
      final ok = context.read<GameState>().tryUnlockFolder(_pin);
      if (ok) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _HiddenFolder()));
      } else {
        setState(() {
          _error = true;
          _pin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, color: _error ? AppTheme.accent : AppTheme.textDim),
            const SizedBox(height: 8),
            Text('PIN da pasta',
                style: TextStyle(
                    color: AppTheme.text, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(_error ? 'PIN incorreto' : 'dica: o ano que ele usa pra tudo',
                style: TextStyle(
                    color: _error ? AppTheme.accent : AppTheme.textDim,
                    fontSize: 12)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 4; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _pin.length
                          ? AppTheme.accent
                          : Colors.transparent,
                      border: Border.all(color: AppTheme.textDim),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            for (final row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['', '0', '⌫'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final d in row)
                    SizedBox(
                      width: 64,
                      height: 52,
                      child: d.isEmpty
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                if (d == '⌫') {
                                  setState(() => _pin = _pin.isEmpty
                                      ? ''
                                      : _pin.substring(0, _pin.length - 1));
                                } else {
                                  _tap(d);
                                }
                              },
                              child: Text(d,
                                  style: TextStyle(
                                      color: AppTheme.text, fontSize: 22)),
                            ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
