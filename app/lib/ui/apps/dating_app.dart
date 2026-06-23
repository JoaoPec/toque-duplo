import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../widgets.dart';

const _pink = Color(0xFFFE3C72);
const _pink2 = Color(0xFFFF655B);

class _Persona {
  const _Persona(this.evId, this.name, this.age, this.emoji, this.bio,
      this.location, this.colors);
  final String evId;
  final String name;
  final int age;
  final String emoji;
  final String bio;
  final String location;
  final List<Color> colors;
}

const _personas = [
  _Persona('profile_rafa', 'Rafa', 31, '🏠',
      'Corretor de imóveis · homem estabelecido · domingo é almoço da família 🍱',
      'Pinheiros, SP', [Color(0xFF3A6073), Color(0xFF16222A)]),
  _Persona('profile_theo', 'Theo', 28, '🏄',
      'Vivo do mar 🌊 Okinawa no sangue · me chama pra um surf',
      'Maresias, SP', [Color(0xFF2980B9), Color(0xFF6DD5FA)]),
  _Persona('profile_gui', 'Gui', 31, '💪',
      'Coach de wellness · mente sã, corpo são · óculos de leitor 🤓',
      'Moema, SP', [Color(0xFF614385), Color(0xFF516395)]),
];

class DatingApp extends StatefulWidget {
  const DatingApp({super.key});
  @override
  State<DatingApp> createState() => _DatingAppState();
}

class _DatingAppState extends State<DatingApp> {
  int _account = 0;

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final visible = g.thirdProfileVisible ? _personas : _personas.take(2).toList();
    if (_account >= visible.length) _account = 0;
    final p = visible[_account];

    return AppShell(
      headerColor: const Color(0xFF101010),
      headerFg: Colors.white,
      title: 'tinder',
      titleWidget: Row(
        children: [
          const Icon(Icons.local_fire_department, color: _pink, size: 26),
          const SizedBox(width: 4),
          const Text('tinder',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Account switcher — the tell: many sessions, one device.
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: const Color(0xFF101010),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < visible.length; i++)
                    GestureDetector(
                      onTap: () => setState(() => _account = i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: i == _account ? _pink : Colors.white24,
                              width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF222222),
                          child: Text(visible[i].emoji,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ProfileCard(persona: p),
                  const SizedBox(height: 20),
                  Text('SUAS CURTIDAS / MATCHES',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _MatchChip('Camila, 29', 'Pinheiros', '🏠 via Rafa',
                      'há 8 meses', () => _openMoved(context, 'Camila')),
                  _MatchChip('Bia, 24', 'Maresias', '🏄 via Theo', 'há 4 meses',
                      () => _openMoved(context, 'Bia')),
                  _MatchChip('Iasmin, 22', 'Moema', '💪 via Gui',
                      'há 2 semanas', () => _openMoved(context, 'Iasmin')),
                  _MatchChip('Jéssica, 27', 'Tatuapé', '🏠 via Rafa',
                      'sem resposta', () => _openGhost(context, 'Jéssica')),
                  _MatchChip('Amanda, 25', 'Santana', '💪 via Gui',
                      'sem resposta', () => _openGhost(context, 'Amanda')),
                  _MatchChip('Carol, 31', 'Brooklin', '🏠 via Rafa', 'ela sumiu',
                      () => _openGhost(context, 'Carol')),
                  _MatchChip('Duda, 23', 'Ubatuba', '🏄 via Theo', 'sem match',
                      () => _openGhost(context, 'Duda')),
                  _MatchChip('Nat, 28', 'Pinheiros', '🏠 via Rafa', 'desfez',
                      () => _openGhost(context, 'Nat')),
                  _MatchChip('Bruna, 26', 'Vila Mariana', '💪 via Gui',
                      'sem resposta', () => _openGhost(context, 'Bruna')),
                  const SizedBox(height: 16),
                  if (g.caseOpen(4))
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const _LeticiaChat())),
                      child: _LeticiaCard(),
                    )
                  else
                    LockedBanner(
                        text:
                            'Tem uma conversa ativa aqui. Mas você ainda não '
                            'juntou o suficiente pra entender por que ela importa '
                            'mais que as outras.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.persona});
  final _Persona persona;
  @override
  Widget build(BuildContext context) {
    final pinned = context.watch<GameState>().isPinned(persona.evId);
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: persona.colors),
        border: pinned ? Border.all(color: _pink, width: 2.5) : null,
      ),
      child: Stack(
        children: [
          Center(
              child: Text(persona.emoji, style: const TextStyle(fontSize: 120))),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: PinButton(evidenceId: persona.evId),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(persona.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text('${persona.age}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 26)),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Colors.white70, size: 20),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 16),
                    Text(persona.location,
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(persona.bio,
                    style: const TextStyle(color: Colors.white, height: 1.3)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('● logado neste aparelho',
                          style:
                              TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchChip extends StatelessWidget {
  const _MatchChip(this.name, this.city, this.via, this.ago, this.onTap);
  final String name, city, via, ago;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF333333),
              child: const Icon(Icons.person, color: Colors.white54)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name · $city',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                Text('$via · sem conversa $ago',
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _LeticiaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pinned = context.watch<GameState>().isPinned('leticia_match');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_pink, _pink2]),
        borderRadius: BorderRadius.circular(14),
        border: pinned ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Row(
        children: [
          const Text('🌸', style: TextStyle(fontSize: 34)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Letícia, 23 — É UM MATCH!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
                const Text('Pinheiros · via Rafa · online agora',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 4),
                const Text('"então é café amanhã mesmo? 😊"',
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 13)),
              ],
            ),
          ),
          PinButton(evidenceId: 'leticia_match'),
        ],
      ),
    );
  }
}

// ── Conversas ──────────────────────────────────────────────────────────────

class _TMsg {
  const _TMsg(this.text, this.mine, {this.system = false, this.audio = false});
  final String text; // audio: duration "0:14"
  final bool mine; // Rafael (a persona)
  final bool system;
  final bool audio;
}

/// Realismo: predador move a conversa pro WhatsApp cedo. Por isso o Tinder só
/// guarda o "match" — o resto está no WhatsApp (e, nas vítimas, foi cortado).
void _openMoved(BuildContext context, String name) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => _TinderChat(
      title: name,
      emoji: '👤',
      messages: const [
        _TMsg('Vocês deram match! 🎉', false, system: true),
        _TMsg('oi! gostei muito do seu perfil 😊', true),
        _TMsg('oii! também curti o seu', false),
        _TMsg('que tal a gente continuar no zap? fica melhor de conversar', true),
        _TMsg('claro, manda', false),
        _TMsg('— conversa movida para outro aplicativo —', false, system: true),
      ],
    ),
  ));
}

/// Matches que não deram em nada — só ruído pra encher a lista.
void _openGhost(BuildContext context, String name) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => _TinderChat(
      title: name,
      emoji: '👤',
      messages: const [
        _TMsg('Vocês deram match! 🎉', false, system: true),
        _TMsg('oii, tudo bem? 😊', true),
        _TMsg('— sem resposta —', false, system: true),
      ],
    ),
  ));
}

class _LeticiaChat extends StatelessWidget {
  const _LeticiaChat();
  @override
  Widget build(BuildContext context) {
    return _TinderChat(
      title: 'Letícia, 23',
      emoji: '🌸',
      pinEvId: 'leticia_match',
      messages: const [
        _TMsg('Vocês deram match! 🎉', false, system: true),
        _TMsg('oii, tudo bem? 😊', false),
        _TMsg('tudo ótimo! adorei seu perfil. vc é de Pinheiros mesmo?', true),
        _TMsg('sou sim! nascida e criada kk e vc trabalha com imóveis?', false),
        _TMsg('isso 🙂 inclusive tenho um lugar incrível pra te mostrar, '
            'vista pro pôr do sol', true),
        _TMsg('aaai que vontade 😍', false),
        _TMsg('vc mora sozinha? pergunto pq tenho uns apês perfeitos pra quem '
            'curte independência', true),
        _TMsg('moro sim, vim de Minas faz 2 anos. família toda lá kk', false),
        _TMsg('que corajosa 🙌 admiro mulher independente. raríssimo', true),
        _TMsg('🥹 vc é diferente sabe, a maioria some', false),
        _TMsg('comigo é diferente. confia 😌', true),
        _TMsg('0:32', true, audio: true),
        _TMsg('aaa que voz gostosa kkk fiquei sem graça 🙈', false),
        _TMsg('então é café amanhã mesmo? te pego, conheço um cantinho que só '
            'quem é daqui conhece 😉', true),
        _TMsg('pode ser! 19h?', false),
        _TMsg('19h. vou de carro, te levo depois. vai ser especial', true),
        _TMsg('melhor não comentar com as amigas ainda, sabe como é, povo '
            'invejoso. deixa ser nosso segredinho 🤫', true),
        _TMsg('kkk tá bom, segredo 🤐 to ansiosa', false),
        _TMsg('eu também. amanhã sua vida muda 😊', true),
        _TMsg('— ela está online agora —', false, system: true),
      ],
    );
  }
}

class _TinderChat extends StatelessWidget {
  const _TinderChat(
      {required this.title,
      required this.emoji,
      required this.messages,
      this.pinEvId});
  final String title;
  final String emoji;
  final List<_TMsg> messages;
  final String? pinEvId;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: const Color(0xFF101010),
      headerFg: Colors.white,
      title: title,
      titleWidget: Row(children: [
        CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF222222),
            child: Text(emoji, style: const TextStyle(fontSize: 16))),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ]),
      actions: [if (pinEvId != null) PinButton(evidenceId: pinEvId!)],
      body: Container(
        color: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            for (final m in messages)
              if (m.system)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(m.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                  ),
                )
              else
                Align(
                  alignment:
                      m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    constraints: const BoxConstraints(maxWidth: 260),
                    decoration: BoxDecoration(
                      gradient: m.mine
                          ? const LinearGradient(colors: [_pink, _pink2])
                          : null,
                      color: m.mine ? null : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: m.audio
                        ? _TinderAudio(duration: m.text)
                        : Text(m.text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                height: 1.3)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _TinderAudio extends StatelessWidget {
  const _TinderAudio({required this.duration});
  final String duration;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Row(
        children: [
          const Icon(Icons.play_arrow, color: Colors.white, size: 24),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 16,
              child: Row(
                children: [
                  for (var i = 0; i < 24; i++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.6),
                        height: 3 + (i * 5 % 11).toDouble(),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(duration,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
