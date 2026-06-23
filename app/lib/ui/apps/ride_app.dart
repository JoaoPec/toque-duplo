import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../../theme.dart';
import '../widgets.dart';

const _ride = Color(0xFFFFD400); // 99 yellow
const _rideBg = Color(0xFF121212);

class _Trip {
  const _Trip(this.from, this.to, this.when, this.price,
      {this.evId, this.minCase = 1, this.flag = false});
  final String from;
  final String to;
  final String when;
  final String price;
  final String? evId;
  final int minCase;
  final bool flag;
}

const _trips = [
  _Trip('Casa', 'Academia Smart Fit', 'hoje · 07:05', 'R\$ 12,40'),
  _Trip('Shopping Eldorado', 'Casa', 'ontem · 22:10', 'R\$ 24,90'),
  _Trip('Casa', 'Restaurante Liberdade', 'domingo · 12:30', 'R\$ 16,80'),
  _Trip('Rodoviária de Maresias', 'Pousada Maré Mansa', '22 fev · 19:42',
      'R\$ 28,90',
      evId: 'ride_rodoviaria', minCase: 3, flag: true),
  _Trip('Casa', 'Imobiliária Prime', 'sex · 09:00', 'R\$ 18,70'),
  _Trip('Bar do Lucas', 'Casa', 'sex · 01:40', 'R\$ 31,20'),
  _Trip('Bar Original — Moema', 'Endereço sem nome', 'jun · 02:14', 'R\$ 41,50',
      evId: 'ride_moema', minCase: 3, flag: true),
  _Trip('Casa', 'Dra. Helena (dentista)', 'qui · 15:40', 'R\$ 14,30'),
  _Trip('Casa', 'Aeroporto de Congonhas', 'mai · 06:10', 'R\$ 33,00',
      evId: 'ride_airport'),
  _Trip('Casa da mãe — Suzano', 'Casa', 'dom · 18:00', 'R\$ 58,00'),
  _Trip('Plantão de venda — Vila Olímpia', 'Casa', '14 mai · 20:00', 'R\$ 21,50'),
  _Trip('Casa', 'Pizzaria Bella', 'qua · 20:30', 'R\$ 9,90'),
  _Trip('Padaria', 'Casa', 'ter · 08:15', 'R\$ 7,50'),
  _Trip('Casa', 'Cartório Pinheiros', 'seg · 11:00', 'R\$ 19,60'),
];

class RideApp extends StatelessWidget {
  const RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: _ride,
      headerFg: Colors.black,
      title: '99',
      titleWidget: Row(children: const [
        Text('99',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900)),
        SizedBox(width: 8),
        Text('Histórico',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
      ]),
      body: Container(
        color: _rideBg,
        child: ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: _trips.length,
          separatorBuilder: (_, _) => Divider(color: AppTheme.line, height: 18),
          itemBuilder: (_, i) {
            final t = _trips[i];
            final pinnable = t.evId != null && g.caseOpen(t.minCase);
            final pinned = t.evId != null && g.isPinned(t.evId!);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle, size: 10, color: AppTheme.textDim),
                    Container(width: 1.5, height: 26, color: AppTheme.line),
                    Icon(Icons.location_on,
                        size: 14, color: t.flag ? AppTheme.accent : _ride),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.from,
                          style: TextStyle(
                              color: AppTheme.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      Text(t.to,
                          style: TextStyle(
                              color: pinned ? AppTheme.accent : AppTheme.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${t.when}  ·  ${t.price}',
                          style: TextStyle(
                              color: AppTheme.textDim, fontSize: 12)),
                    ],
                  ),
                ),
                if (pinnable) PinButton(evidenceId: t.evId!, dense: true),
              ],
            );
          },
        ),
      ),
    );
  }
}
