import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../game/deduction.dart';
import '../game/evidence.dart';
import '../game/game_state.dart';
import '../theme.dart';
import 'widgets.dart';

class DossierScreen extends StatefulWidget {
  const DossierScreen({super.key});
  @override
  State<DossierScreen> createState() => _DossierScreenState();
}

class _DossierScreenState extends State<DossierScreen> {
  final Set<String> _selected = {};

  void _connect(GameState g) {
    final beforeCase = g.caseIndex;
    final result = g.connect(Set.of(_selected));
    if (result == ConnectResult.linked) {
      HapticFeedback.mediumImpact();
      setState(_selected.clear);
      final deduction = Deductions.all.firstWhere((d) => d.id == g.lastDeductionId);
      if (g.caseIndex > beforeCase) {
        _showCaseClosed(deduction, beforeCase);
        return;
      }
    } else {
      HapticFeedback.lightImpact();
    }
    final msg = switch (result) {
      ConnectResult.linked => 'Conexão! ${_lastTitle(g)}',
      ConnectResult.already => 'Você já tinha ligado essas provas.',
      ConnectResult.needPin => 'Selecione pelo menos duas provas.',
      ConnectResult.none =>
        'Essas provas não se ligam. Você perde tempo — e bateria.',
    };
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        backgroundColor:
            result == ConnectResult.linked ? AppTheme.good : AppTheme.surfaceHi,
        content: Text(msg,
            style: TextStyle(
                color: result == ConnectResult.linked
                    ? Colors.black
                    : AppTheme.text,
                fontWeight: FontWeight.w600)),
      ));
  }

  void _showCaseClosed(Deduction d, int closedCase) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: AppTheme.good, size: 48),
              const SizedBox(height: 12),
              Text('CASO $closedCase FECHADO',
                  style: TextStyle(
                      color: AppTheme.good,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
              const SizedBox(height: 10),
              Text(d.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.text,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(d.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.textDim, fontSize: 13, height: 1.45)),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppTheme.accent),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continuar a investigação'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestHint(GameState g) {
    final hint = g.requestHint();
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        icon: Icon(Icons.lightbulb,
            color: hint == null ? AppTheme.textDim : AppTheme.accent),
        title: Text(hint == null ? 'Sem mais dicas' : 'Dica (−5% bateria)',
            style: TextStyle(color: AppTheme.text, fontSize: 16)),
        content: Text(
            hint ??
                'Você já gastou todas as dicas deste caso. O resto é com você.',
            style: TextStyle(color: AppTheme.textDim, height: 1.45)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: AppTheme.accent)),
          ),
        ],
      ),
    );
  }

  String _lastTitle(GameState g) {
    final id = g.lastDeductionId;
    if (id == null) return '';
    return Deductions.all.firstWhere((d) => d.id == id).title;
  }

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final pinned = Ev.all.where((e) => g.isPinned(e.id)).toList();
    final madeDeductions =
        Deductions.all.where((d) => g.hasDeduction(d.id)).toList();

    return AppShell(
      headerColor: AppTheme.bg,
      headerFg: AppTheme.text,
      title: 'Dossiê',
      titleWidget: Row(children: [
        Icon(Icons.fact_check, color: AppTheme.accent),
        const SizedBox(width: 8),
        Text('Dossiê',
            style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CaseCard(g: g),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: g.hintsRemaining > 0 ? () => _requestHint(g) : null,
              icon: Icon(Icons.lightbulb_outline,
                  size: 18,
                  color: g.hintsRemaining > 0
                      ? AppTheme.accent
                      : AppTheme.textDim),
              label: Text(
                  g.hintsRemaining > 0
                      ? 'Pedir dica  (−5%)  ·  ${g.hintsRemaining} restantes'
                      : 'Sem dicas neste caso',
                  style: TextStyle(
                      color: g.hintsRemaining > 0
                          ? AppTheme.accent
                          : AppTheme.textDim,
                      fontSize: 12.5)),
            ),
          ),
          const SizedBox(height: 8),
          _sectionTitle('CONEXÕES FEITAS', '${madeDeductions.length}/${Deductions.all.length}'),
          const SizedBox(height: 8),
          if (madeDeductions.isEmpty)
            _emptyHint(
                'Nenhuma ainda. Ligue duas provas no quadro abaixo pra formar uma '
                'conclusão.')
          else
            for (final d in madeDeductions) _DeductionTile(d: d),
          const SizedBox(height: 18),
          _sectionTitle('QUADRO DE PROVAS', '${pinned.length} fixadas'),
          const SizedBox(height: 4),
          Text(
              'Toque pra selecionar (até 3) e tente conectar. Nem toda prova '
              'leva a algo — parte é ruído.',
              style: TextStyle(color: AppTheme.textDim, fontSize: 12, height: 1.4)),
          const SizedBox(height: 12),
          if (pinned.isEmpty)
            _emptyHint(
                'Vazio. Abra os apps e segure (ou toque no 📌) nas frases, fotos e '
                'lançamentos que te cheirarem mal.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in pinned)
                  _EvChip(
                    ev: e,
                    selected: _selected.contains(e.id),
                    onTap: () => setState(() {
                      if (_selected.contains(e.id)) {
                        _selected.remove(e.id);
                      } else if (_selected.length < 3) {
                        _selected.add(e.id);
                      }
                    }),
                    onUnpin: () => setState(() {
                      _selected.remove(e.id);
                      g.togglePin(e.id);
                    }),
                  ),
              ],
            ),
          const SizedBox(height: 14),
          if (pinned.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _selected.length >= 2
                      ? AppTheme.accent
                      : AppTheme.surfaceHi,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _selected.length >= 2 ? () => _connect(g) : null,
                icon: const Icon(Icons.hub),
                label: Text('CONECTAR (${_selected.length})',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          const SizedBox(height: 20),
          if (g.accusationReady) const _Accusation(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t, String trailing) => Row(
        children: [
          Expanded(
            child: Text(t,
                style: TextStyle(
                    color: AppTheme.textDim,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800)),
          ),
          Text(trailing,
              style: TextStyle(color: AppTheme.textDim, fontSize: 12)),
        ],
      );

  Widget _emptyHint(String t) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.line)),
        child: Text(t,
            style:
                TextStyle(color: AppTheme.textDim, fontSize: 13, height: 1.4)),
      );
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.g});
  final GameState g;
  @override
  Widget build(BuildContext context) {
    final c = g.currentCase;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppTheme.accent.withValues(alpha: 0.22),
          AppTheme.surface,
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= 4; i++) ...[
                Icon(
                    i < g.caseIndex
                        ? Icons.check_circle
                        : i == g.caseIndex
                            ? Icons.radio_button_checked
                            : Icons.lock,
                    size: 16,
                    color: i <= g.caseIndex
                        ? AppTheme.accent
                        : AppTheme.textDim),
                if (i < 4)
                  Expanded(
                      child: Container(
                          height: 2,
                          color: i < g.caseIndex
                              ? AppTheme.accent
                              : AppTheme.line)),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(c.title,
              style: TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(c.question,
              style:
                  TextStyle(color: AppTheme.text, fontSize: 13.5, height: 1.4)),
        ],
      ),
    );
  }
}

class _DeductionTile extends StatelessWidget {
  const _DeductionTile({required this.d});
  final Deduction d;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.good.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.good.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: AppTheme.good, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.title,
                    style: TextStyle(
                        color: AppTheme.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(d.text,
                    style: TextStyle(
                        color: AppTheme.textDim, fontSize: 12.5, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EvChip extends StatelessWidget {
  const _EvChip({
    required this.ev,
    required this.selected,
    required this.onTap,
    required this.onUnpin,
  });
  final Evidence ev;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onUnpin;

  @override
  Widget build(BuildContext context) {
    final c = sourceColor(ev.source);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onUnpin,
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.18)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppTheme.accent : AppTheme.line,
              width: selected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(ev.source,
                        style: TextStyle(
                            color: c,
                            fontSize: 9,
                            fontWeight: FontWeight.w800))),
                const Spacer(),
                if (selected)
                  Icon(Icons.check_circle, color: AppTheme.accent, size: 16),
              ],
            ),
            const SizedBox(height: 6),
            Text(ev.label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Accusation extends StatefulWidget {
  const _Accusation();
  @override
  State<_Accusation> createState() => _AccusationState();
}

class _AccusationState extends State<_Accusation> {
  String? _victim;
  String? _place;
  static const _victims = {
    'marina': 'Marina (do trabalho)',
    'iasmin': 'Iasmin Carvalho',
    'leticia': 'Letícia, 23',
    'aline': 'Aline Bittencourt',
  };
  static const _places = {
    'maresias': 'Maresias',
    'moema': 'Moema',
    'campos': 'Campos do Jordão',
    'pinheiros': 'Pinheiros',
  };

  @override
  Widget build(BuildContext context) {
    final ready = _victim != null && _place != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [AppTheme.accent.withValues(alpha: 0.2), AppTheme.surface]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MONTAR A ACUSAÇÃO',
              style: TextStyle(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1)),
          const SizedBox(height: 6),
          Text('Uma chance antes do café. Quem ele vai encontrar — e onde?',
              style:
                  TextStyle(color: AppTheme.text, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          _drop('A próxima vítima', _victims, _victim,
              (v) => setState(() => _victim = v)),
          const SizedBox(height: 10),
          _drop('O local do encontro', _places, _place,
              (v) => setState(() => _place = v)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: ready ? AppTheme.accent : AppTheme.surfaceHi,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: ready
                  ? () => context.read<GameState>().submitAccusation(
                      victimId: _victim!, placeId: _place!)
                  : null,
              icon: const Icon(Icons.send),
              label: const Text('ENVIAR E ALERTAR',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drop(String label, Map<String, String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: AppTheme.textDim,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.line)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: AppTheme.surfaceHi,
              value: value,
              hint: Text('selecione…',
                  style: TextStyle(color: AppTheme.textDim)),
              style: TextStyle(color: AppTheme.text),
              items: [
                for (final e in items.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
