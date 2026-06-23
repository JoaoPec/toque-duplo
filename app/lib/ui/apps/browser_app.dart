import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../widgets.dart';

const _chromeBg = Color(0xFF202124);
const _chromeBar = Color(0xFF35363A);

class _Tab {
  const _Tab(this.title, this.url, this.body, {this.evId, this.minCase = 1});
  final String title;
  final String url;
  final String body;
  final String? evId;
  final int minCase;
}

const _history = [
  _Tab('Como excluir match permanentemente — sem a pessoa ver', 'google.com/search',
      'Resultados sobre apagar conversas e contas de apps de namoro sem deixar '
      'rastro. Também: "remover geolocalização (geotag) das fotos".',
      evId: 'search_delete'),
  _Tab('G1 — Terapeuta some após encontro por aplicativo',
      'g1.globo.com/sp/pinheiros',
      'Camila Ferraz, 29, terapeuta de Pinheiros, está desaparecida há 8 meses. '
      'O caso foi arquivado como "viagem voluntária" — ela tinha histórico de '
      'viajar sem avisar.',
      evId: 'news_pinheiros', minCase: 3),
  _Tab('Instrutora de surf desaparece no Litoral Norte', 'litoralnews.com.br',
      'Beatriz Konno, 24, sumiu em fevereiro. A família afirma que ela ia '
      'encontrar alguém na rodoviária. Nipo-brasileira, sem histórico de fuga.',
      evId: 'news_maresias', minCase: 3),
  _Tab('Estudante de Direito desaparecida há 2 semanas — Moema',
      'agorasp.com.br/moema',
      'Iasmin Carvalho, 22, vista pela última vez saindo para um encontro. Caso '
      'aberto. Polícia pede informações.',
      evId: 'news_moema', minCase: 3),
  _Tab('CRECI-SP — renovação de inscrição', 'creci.org.br', 'Portal do corretor.'),
  _Tab('Tabela FIPE — consulta de veículo', 'fipe.org.br', 'Consulta de preço.'),
  _Tab('Melhores pousadas em Maresias 2024', 'tripadvisor.com.br',
      'Ranking de pousadas no Litoral Norte.'),
  _Tab('Como fazer poke bowl em casa', 'tudogostoso.com.br', 'Receita.'),
  _Tab('Resultado Brasileirão — rodada 12', 'ge.globo.com', 'Tabela e gols.'),
  _Tab('iPhone 15 vale a pena? review', 'youtube.com', 'Vídeo de review.'),
  _Tab('Treino de perna para hipertrofia', 'bodybuilding.com', 'Guia de treino.'),
  _Tab('Previsão do tempo Campos do Jordão', 'climatempo.com.br', 'Frio na serra.'),
  _Tab('Financiamento imobiliário simulação', 'caixa.gov.br', 'Simulador.'),
];

class BrowserApp extends StatelessWidget {
  const BrowserApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: _chromeBg,
      headerFg: Colors.white,
      title: 'Chrome',
      titleWidget: Row(children: [
        const Icon(Icons.public, color: Color(0xFF4285F4)),
        const SizedBox(width: 8),
        const Text('Chrome',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ]),
      body: Container(
        color: _chromeBg,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Histórico',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ),
            for (final t in _history)
              ListTile(
                leading: const Icon(Icons.history, color: Colors.white38),
                title: Text(t.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text(t.url,
                    style: const TextStyle(
                        color: Color(0xFF8AB4F8), fontSize: 12)),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => _PageScreen(tab: t))),
              ),
          ],
        ),
      ),
    );
  }
}

class _PageScreen extends StatelessWidget {
  const _PageScreen({required this.tab});
  final _Tab tab;
  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final pinnable = tab.evId != null && g.caseOpen(tab.minCase);
    return AppShell(
      headerColor: _chromeBar,
      headerFg: Colors.white,
      title: tab.url,
      titleWidget: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: _chromeBg, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          const Icon(Icons.lock, color: Colors.white38, size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(tab.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ]),
      ),
      actions: [if (pinnable) PinButton(evidenceId: tab.evId!)],
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(tab.title,
                style: const TextStyle(
                    color: Color(0xFF202124),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3)),
            const SizedBox(height: 16),
            Text(tab.body,
                style: const TextStyle(
                    color: Color(0xFF3C4043), fontSize: 16, height: 1.55)),
          ],
        ),
      ),
    );
  }
}
