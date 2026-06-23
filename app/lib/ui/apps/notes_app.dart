import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets.dart';

const _noteYellow = Color(0xFFFFD60A);
const _noteBg = Color(0xFF1C1C1E);

class _Note {
  const _Note(this.title, this.date, this.lines, {this.evId});
  final String title;
  final String date;
  final List<String> lines;
  final String? evId;
}

const _notes = [
  _Note('clientes', '12/06', [
    'Camila — Pinheiros — out — encerrado ✗',
    'Bia — Maresias — fev — encerrado ✗',
    'Iasmin — Moema — jun — em aberto',
    'Letícia — Pinheiros — — — prospect',
  ], evId: 'client_list'),
  _Note('senhas', '03/01', [
    'email 2: rafa.imoveis.sp@—',
    'wifi casa: liberdade62',
    'tudo é 1962, não esquece',
  ], evId: 'note_creci'),
  _Note('lembretes', 'ontem', [
    '• comprar o doce da vó (domingo)',
    '• pagar DARF',
    '• renovar CRECI',
    '• comprar flores',
  ]),
  _Note('frases', '—', [
    '"meus avós vieram do Japão sem nada"',
    '"domingo é sagrado"',
    '"minha família também é de Okinawa"',
  ]),
  _Note('roteiro', '02/02', [
    'ideia: personagem some sem deixar pista',
    'levar pra longe, lugar sem câmera, sem celular',
    'ninguém procura quem "viaja sem avisar"',
    '(rascunho pro podcast de true crime??)',
  ], evId: 'note_rascunho'),
  _Note('lista de mercado', 'sáb', [
    'arroz, feijão',
    'whey, ovos (3 dúzias)',
    'café, filtro',
    'sabão, esponja',
  ]),
  _Note('presentes', '—', [
    'vó: lenço de seda',
    'mãe: perfume',
    'sobrinho: tênis 38',
  ]),
  _Note('apês p/ mostrar', 'qui', [
    'Vila Olímpia 2q — casal Jorge',
    'Pinheiros cobertura — visita marcada',
    'Moema studio — investidor',
  ]),
  _Note('treino', '—', [
    'seg: peito/tríceps',
    'qua: costas/bíceps',
    'sex: perna (não pular!)',
  ]),
  _Note('filmes p/ ver', '—', [
    'O Poderoso Chefão',
    'Clube da Luta',
    'Parasita',
  ]),
];

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: _noteBg,
      headerFg: _noteYellow,
      title: 'Notas',
      titleWidget: Text('Notas',
          style: TextStyle(
              color: _noteYellow, fontSize: 20, fontWeight: FontWeight.w700)),
      body: Container(
        color: const Color(0xFF000000),
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _notes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final n = _notes[i];
            return InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => _NoteScreen(note: n))),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: _noteBg, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n.title,
                        style: TextStyle(
                            color: AppTheme.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${n.date}   ${n.lines.first}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppTheme.textDim, fontSize: 13)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NoteScreen extends StatelessWidget {
  const _NoteScreen({required this.note});
  final _Note note;
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: _noteBg,
      headerFg: _noteYellow,
      title: note.title,
      actions: [if (note.evId != null) PinButton(evidenceId: note.evId!)],
      body: Container(
        color: const Color(0xFF000000),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(note.title,
                style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(note.date, style: TextStyle(color: AppTheme.textDim)),
            const SizedBox(height: 16),
            for (final l in note.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(l,
                    style: TextStyle(
                        color: AppTheme.text, fontSize: 16, height: 1.45)),
              ),
          ],
        ),
      ),
    );
  }
}
