import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../../theme.dart';
import '../widgets.dart';

const _nuPurple = Color(0xFF820AD1);

class _Tx {
  const _Tx(this.icon, this.desc, this.date, this.amount,
      {this.evId, this.minCase = 1});
  final IconData icon;
  final String desc;
  final String date;
  final String amount;
  final String? evId;
  final int minCase;
}

const _txs = [
  _Tx(Icons.local_florist, 'Floricultura Flor & Cia — Pinheiros', 'ontem',
      '- R\$ 95,00', evId: 'bank_flor', minCase: 4),
  _Tx(Icons.fastfood, 'iFood — Temakeria Liberdade', 'ontem', '- R\$ 78,40'),
  _Tx(Icons.local_gas_station, 'Posto Shell Ipiranga', 'ontem', '- R\$ 250,00'),
  _Tx(Icons.subscriptions, 'Netflix', 'anteontem', '- R\$ 44,90'),
  _Tx(Icons.music_note, 'Spotify Premium', 'anteontem', '- R\$ 21,90'),
  _Tx(Icons.local_taxi, '99 — corrida', 'anteontem', '- R\$ 19,80'),
  _Tx(Icons.restaurant, 'Restaurante Liberdade', 'domingo', '- R\$ 220,00'),
  _Tx(Icons.local_cafe, 'Padaria Bella Vista', 'domingo', '- R\$ 32,50'),
  _Tx(Icons.fitness_center, 'Smart Fit — mensalidade', 'sex', '- R\$ 119,90'),
  _Tx(Icons.shopping_cart, 'Mercado Pão de Açúcar', 'sex', '- R\$ 312,77'),
  _Tx(Icons.attach_money, 'Imobiliária Prime — comissão', '15 mai',
      '+ R\$ 7.200,00', evId: 'bank_comissao'),
  _Tx(Icons.shopping_bag, 'Amazon — compra', '14 mai', '- R\$ 89,90'),
  _Tx(Icons.medical_services, 'Drogaria Pague Menos', '12 mai', '- R\$ 64,30'),
  _Tx(Icons.cabin, 'Chalé Pinheiral — Campos do Jordão', 'jun', '- R\$ 890,00',
      minCase: 3),
  _Tx(Icons.pix, 'PIX — Pelada de Quinta (quadra)', 'jun', '- R\$ 40,00'),
  _Tx(Icons.local_bar, 'Bar Original — Moema', 'jun', '- R\$ 137,00', minCase: 3),
  _Tx(Icons.king_bed, 'Pousada Maré Mansa — Maresias', '21 fev',
      '- R\$ 540,00', evId: 'bank_pousada', minCase: 3),
  _Tx(Icons.pix, 'PIX enviado — "presente 🎁"', '22 fev', '- R\$ 180,00',
      minCase: 3),
  _Tx(Icons.directions_boat, 'Balsa Maresias/Ilhabela', 'fev', '- R\$ 28,00'),
  _Tx(Icons.fastfood, 'McDonalds Drive', 'fev', '- R\$ 41,60'),
  _Tx(Icons.phone_iphone, 'Vivo — fatura celular', 'fev', '- R\$ 119,90'),
  _Tx(Icons.tv, 'Disney+', 'fev', '- R\$ 33,90'),
  _Tx(Icons.local_pharmacy, 'Farmácia São Paulo', 'jan', '- R\$ 27,80'),
];

class BankApp extends StatelessWidget {
  const BankApp({super.key});
  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: _nuPurple,
      headerFg: Colors.white,
      title: 'Nubank',
      body: Container(
        color: const Color(0xFF000000),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              color: _nuPurple,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Olá, Rafael',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 10),
                  const Text('Saldo disponível',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('R\$ 11.430,55',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Histórico',
                  style: TextStyle(
                      color: AppTheme.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            for (final tx in _txs)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF1A1A1A),
                        child:
                            Icon(tx.icon, color: Colors.white70, size: 18)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.desc,
                              style: TextStyle(
                                  color: AppTheme.text, fontSize: 14)),
                          Text(tx.date,
                              style: TextStyle(
                                  color: AppTheme.textDim, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(tx.amount,
                        style: TextStyle(
                            color: tx.amount.startsWith('+')
                                ? const Color(0xFF34A853)
                                : AppTheme.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    if (tx.evId != null && g.caseOpen(tx.minCase))
                      PinButton(evidenceId: tx.evId!, dense: true)
                    else
                      const SizedBox(width: 40),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
