import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../../theme.dart';
import '../widgets.dart';

const _calBlue = Color(0xFF4285F4);
const _calRed = Color(0xFFEA4335);
const _calGreen = Color(0xFF34A853);

class _Ev {
  const _Ev(this.day, this.title, this.time, this.color,
      {this.evId, this.minCase = 1});
  final String day;
  final String title;
  final String time;
  final Color color;
  final String? evId;
  final int minCase;
}

const _events = [
  _Ev('SEG', 'Academia 7h', '07:00', _calGreen),
  _Ev('SEG', 'Reunião imobiliária', '09:00', _calBlue),
  _Ev('TER', 'Dentista — Dra. Helena', '16:00', _calBlue),
  _Ev('QUA', 'Visita apê Vila Olímpia', '10:00', _calBlue),
  _Ev('QUI', 'Pelada ⚽', '21:00', _calGreen),
  _Ev('DOM', 'Almoço da família', '12:00', _calGreen, evId: 'cal_domingo'),
  _Ev('SEX', 'Plantão de venda', '19:00', _calBlue),
  _Ev('22 FEV', 'Viagem — Maresias', 'fim de semana', _calRed,
      evId: 'cal_maresias', minCase: 3),
  _Ev('MAR', 'Aniversário da mãe 🎂', '', _calGreen),
  _Ev('ABR', 'Vistoria de imóvel', '14:00', _calBlue),
  _Ev('JUN', 'Reunião Moema', '21:00', _calBlue, minCase: 3),
  _Ev('JUN', 'Viagem — Campos do Jordão', 'chalé', _calRed, minCase: 3),
  _Ev('JUN', 'Consulta — dermatologista', '11:00', _calBlue),
  _Ev('—', 'Viagem — Trancoso/BA', '', _calRed, minCase: 3),
  _Ev('—', 'Renovar CRECI', '', _calGreen),
  _Ev('depois de amanhã', 'café — L., Pinheiros', '19:00', _calRed,
      evId: 'cafe_calendar', minCase: 4),
];

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});
  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Agenda',
      titleWidget: Row(children: [
        Icon(Icons.calendar_today, color: _calBlue, size: 20),
        const SizedBox(width: 8),
        Text('Agenda',
            style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: _events.length,
        separatorBuilder: (_, _) => Divider(color: AppTheme.line, height: 18),
        itemBuilder: (_, i) {
          final e = _events[i];
          final pinnable = e.evId != null && g.caseOpen(e.minCase);
          final pinned = e.evId != null && g.isPinned(e.evId!);
          return Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(e.day,
                    style: TextStyle(
                        color: AppTheme.textDim,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
              Container(width: 3, height: 38, color: e.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title,
                        style: TextStyle(
                            color: pinned ? AppTheme.accent : AppTheme.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    if (e.time.isNotEmpty)
                      Text(e.time,
                          style:
                              TextStyle(color: AppTheme.textDim, fontSize: 12)),
                  ],
                ),
              ),
              if (pinnable) PinButton(evidenceId: e.evId!, dense: true),
            ],
          );
        },
      ),
    );
  }
}
