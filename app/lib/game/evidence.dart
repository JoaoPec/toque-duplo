import 'package:flutter/material.dart';

/// A single, *neutral* fragment the player can pin to the corkboard. Crucially,
/// evidence is never a conclusion — it's a fact. The game never tells you which
/// fragments matter. You decide what to pin, then you try to connect pieces.
///
/// Many fragments are noise (`herring: true`) — innocent explanations and
/// dead ends that look suspicious. The `herring` flag is for internal tuning
/// and is never surfaced in the UI.
class Evidence {
  const Evidence({
    required this.id,
    required this.source,
    required this.label,
    required this.snippet,
    required this.icon,
    this.herring = false,
    this.minCase = 1,
  });

  final String id;
  final String source; // app it lives in
  final String label; // short name on the corkboard chip
  final String snippet; // the actual fragment text
  final IconData icon;
  final bool herring;
  final int minCase; // not pinnable before this case is open
}

class Ev {
  Ev._();

  // ── WhatsApp ──────────────────────────────────────────────────────────
  static const marinaFlirt = Evidence(
    id: 'marina_flirt',
    source: 'WhatsApp',
    label: 'Marina — "ontem foi bom demais"',
    snippet:
        'Conversa com "Marina (trampo)": flerte explícito, "semana que vem de '
        'novo?", "e a tal da namorada?" → "relaxa, questão de tempo".',
    icon: Icons.chat,
  );
  static const alineExcuse = Evidence(
    id: 'aline_excuse',
    source: 'WhatsApp',
    label: 'Aline — desculpas de fim de semana',
    snippet:
        '"reunião amor" às 23h de sábado; "boa noite" às 3h17 de domingo. '
        'Sumiços que não fecham com a agenda dele.',
    icon: Icons.chat,
  );
  static const familiaOculos = Evidence(
    id: 'familia_oculos',
    source: 'WhatsApp',
    label: 'Vó — "tira esses óculos de mentira"',
    snippet:
        'No grupo da família, a avó: "menino, tira essa foto de óculos, você '
        'nunca precisou de grau". Ele: "é coisa de trabalho vó 😅".',
    icon: Icons.chat,
  );
  static const familiaLoja = Evidence(
    id: 'familia_loja',
    source: 'WhatsApp',
    label: 'Família — a loja do vô',
    snippet:
        '"mãe, emoldurei a foto da inauguração da loja do vô, 1962, Liberdade". '
        'Ele usa muito esse ano — senha de tudo.',
    icon: Icons.chat,
    herring: true, // …mas é a dica do PIN da pasta oculta
  );
  static const biaChatCut = Evidence(
    id: 'bia_chat_cut',
    source: 'WhatsApp',
    label: 'B. — conversa que para no meio',
    snippet:
        'Arquivada há 4 meses. Última mensagem dela: "chego 19h, ônibus de '
        'Maresias, fica no portão 3 que eu". Depois disso a conversa para no '
        'meio de uma frase. Nunca mais.',
    icon: Icons.archive,
    minCase: 3,
  );
  static const jorgeWork = Evidence(
    id: 'jorge_work',
    source: 'WhatsApp',
    label: 'Jorge (corretor) — papo de trabalho',
    snippet:
        '"fechou o apê da Vila Olímpia?" "fechou, comissão cai dia 15". Papo '
        'normal de corretagem.',
    icon: Icons.chat,
    herring: true,
  );
  static const camilaChatCut = Evidence(
    id: 'camila_chat_cut',
    source: 'WhatsApp',
    label: 'Camila — conversa que some há 8 meses',
    snippet:
        'Arquivada. "Rafa Imóveis" marcou de mostrar um apê em Pinheiros pra ela. '
        'Última mensagem dela: "tô subindo, qual andar?". Depois, silêncio total.',
    icon: Icons.archive,
    minCase: 3,
  );
  static const iasminChatCut = Evidence(
    id: 'iasmin_chat_cut',
    source: 'WhatsApp',
    label: 'Iasmin — conversa que some há 2 semanas',
    snippet:
        'Arquivada. "Gui Mendes" marcou de buscá-la num bar em Moema. Última '
        'mensagem dela: "tô te esperando na esquina, é esse carro prata?". '
        'Depois, nada. Faz duas semanas.',
    icon: Icons.archive,
    minCase: 3,
  );
  static const unknownNumber = Evidence(
    id: 'unknown_number',
    source: 'WhatsApp',
    label: 'Número desconhecido — "sei o que você fez"',
    snippet:
        'Mensagem de um número não salvo: "eu sei o que você fez com elas". '
        'Ele respondeu com 😂 e bloqueou. (Trote? Ou alguém que sabe?)',
    icon: Icons.block,
    herring: true,
  );

  // ── 99 (corridas) ─────────────────────────────────────────────────────
  static const rideRodoviaria = Evidence(
    id: 'ride_rodoviaria',
    source: '99',
    label: 'Corrida — Rodoviária de Maresias, 22 fev',
    snippet:
        '22/02 · 19:42 · Rodoviária de Maresias → Pousada Maré Mansa. '
        '"2 passageiros". A Bia disse que chegava 19h de ônibus.',
    icon: Icons.local_taxi,
    minCase: 3,
  );
  static const rideMoema = Evidence(
    id: 'ride_moema',
    source: '99',
    label: 'Corrida — Moema, madrugada',
    snippet:
        'Jun · 02:14 · Bar em Moema → endereço sem nome salvo. Sozinho? "2 '
        'passageiros". Mesma semana da Iasmin.',
    icon: Icons.local_taxi,
    minCase: 3,
  );
  static const rideAirport = Evidence(
    id: 'ride_airport',
    source: '99',
    label: 'Corrida — Congonhas',
    snippet: 'Ida ao aeroporto, voo de trabalho. Recibo normal.',
    icon: Icons.local_taxi,
    herring: true,
  );

  // ── Fotos (galeria) ───────────────────────────────────────────────────
  static const glassesSelfie = Evidence(
    id: 'glasses_selfie',
    source: 'Fotos',
    label: 'Selfie de óculos ("perfil 3")',
    snippet:
        'Rafael de óculos de grau, regata, espelho de academia. Nome do arquivo: '
        '"perfil_3_gui.jpg". Mas ele não usa óculos.',
    icon: Icons.image,
    minCase: 2,
  );
  static const theoSelfie = Evidence(
    id: 'theo_selfie',
    source: 'Fotos',
    label: 'Selfie de boné e barba ("perfil 2")',
    snippet:
        'Boné, barba por fazer, prancha. "perfil_2_theo.jpg". Outro visual, '
        'outra pessoa — a mesma pessoa.',
    icon: Icons.image,
    minCase: 2,
  );
  static const geotagMaresias = Evidence(
    id: 'geotag_maresias',
    source: 'Fotos',
    label: 'EXIF — Maresias, 22 fev',
    snippet:
        'Foto de pôr do sol. Metadados GPS: Maresias/SP, 22/02 14:30 — mesmo dia '
        'em que ele disse à Aline que estava "em SP, trabalhando".',
    icon: Icons.location_on,
    minCase: 2,
  );
  static const trophyStories = Evidence(
    id: 'trophy_stories',
    source: 'Fotos',
    label: '3 prints de stories',
    snippet:
        'Três prints guardados: o último story de Camila, de Bia e de Iasmin — '
        'cada um datado de poucas horas antes de cada uma sumir.',
    icon: Icons.collections,
    minCase: 3,
  );
  static const albumBeach = Evidence(
    id: 'album_beach',
    source: 'Fotos',
    label: 'Álbum — praia',
    snippet: 'Fotos normais de praia, churrasco, prédios à venda.',
    icon: Icons.image,
    herring: true,
  );

  // ── Tinder ────────────────────────────────────────────────────────────
  static const profileRafa = Evidence(
    id: 'profile_rafa',
    source: 'Tinder',
    label: 'Perfil "Rafa Imóveis", 31',
    snippet: 'Conta logada. Corretor, terno, "homem estabelecido".',
    icon: Icons.local_fire_department,
    minCase: 2,
  );
  static const profileTheo = Evidence(
    id: 'profile_theo',
    source: 'Tinder',
    label: 'Perfil "Theo Maré", 28',
    snippet: 'Conta logada no MESMO aparelho. Surfista, tira 3 anos da idade.',
    icon: Icons.local_fire_department,
    minCase: 2,
  );
  static const profileGui = Evidence(
    id: 'profile_gui',
    source: 'Tinder',
    label: 'Perfil "Gui Mendes", 31',
    snippet: 'Terceira conta logada. Coach de wellness, óculos, Moema.',
    icon: Icons.local_fire_department,
    minCase: 2,
  );
  static const leticiaMatch = Evidence(
    id: 'leticia_match',
    source: 'Tinder',
    label: 'Match ativo — Letícia, 23',
    snippet:
        'Pinheiros, via "Rafa Imóveis", online agora. "então é café amanhã '
        'mesmo? 😊". Ela está viva.',
    icon: Icons.favorite,
    minCase: 4,
  );

  // ── Notas ─────────────────────────────────────────────────────────────
  static const clientList = Evidence(
    id: 'client_list',
    source: 'Notas',
    label: 'Nota "clientes" com status',
    snippet:
        'Camila/Pinheiros/out/encerrado, Bia/Maresias/fev/encerrado, '
        'Iasmin/Moema/jun/em aberto, Letícia/Pinheiros/—/prospect. '
        'Alguns riscados.',
    icon: Icons.sticky_note_2,
    minCase: 3,
  );
  static const noteCreci = Evidence(
    id: 'note_creci',
    source: 'Notas',
    label: 'Nota "senhas"',
    snippet: 'email 2: rafa.imoveis.sp@— · "tudo é 1962, não esquece".',
    icon: Icons.sticky_note_2,
    herring: true,
  );
  static const noteRascunho = Evidence(
    id: 'note_rascunho',
    source: 'Notas',
    label: 'Rascunho — "roteiro"',
    snippet:
        'Um rascunho que parece falar em "fazer sumir sem deixar pista". No fim: '
        '"(ideia pro podcast de true crime)". Calafrio — mas pode ser só isso.',
    icon: Icons.sticky_note_2,
    herring: true,
  );

  // ── Agenda (calendário) ───────────────────────────────────────────────
  static const calMaresias = Evidence(
    id: 'cal_maresias',
    source: 'Agenda',
    label: 'Viagem — Maresias, 22 fev',
    snippet: 'Bloqueio de fim de semana. Mesma data do último contato da "B.".',
    icon: Icons.event,
    minCase: 3,
  );
  static const cafeCalendar = Evidence(
    id: 'cafe_calendar',
    source: 'Agenda',
    label: '"café — L., Pinheiros, 19h"',
    snippet:
        'Depois de amanhã, 19h. "L.". Mas Iasmin sumiu há 2 semanas — esse "L." '
        'é a Letícia.',
    icon: Icons.event,
    minCase: 4,
  );
  static const calDomingo = Evidence(
    id: 'cal_domingo',
    source: 'Agenda',
    label: 'Almoço de domingo',
    snippet: 'Recorrente, casa da mãe, todo domingo 12h.',
    icon: Icons.event,
    herring: true,
  );

  // ── Chrome (navegador) ────────────────────────────────────────────────
  static const newsPinheiros = Evidence(
    id: 'news_pinheiros',
    source: 'Chrome',
    label: 'Notícia — sumiço em Pinheiros',
    snippet:
        '"Terapeuta some após encontro por aplicativo. Pinheiros." Há 8 meses. '
        'Caso arquivado como "viagem voluntária".',
    icon: Icons.public,
    minCase: 3,
  );
  static const newsMaresias = Evidence(
    id: 'news_maresias',
    source: 'Chrome',
    label: 'Notícia — sumiço em Maresias',
    snippet:
        '"Instrutora de surf desaparece no Litoral Norte." Fevereiro. Família '
        'diz que ela ia buscar alguém na rodoviária.',
    icon: Icons.public,
    minCase: 3,
  );
  static const newsMoema = Evidence(
    id: 'news_moema',
    source: 'Chrome',
    label: 'Notícia — sumiço em Moema',
    snippet:
        '"Estudante de Direito desaparecida há 2 semanas. Moema." Caso aberto, '
        'ainda quente.',
    icon: Icons.public,
    minCase: 3,
  );
  static const searchDelete = Evidence(
    id: 'search_delete',
    source: 'Chrome',
    label: 'Busca — apagar conta sem rastro',
    snippet:
        '"como excluir match permanentemente sem a pessoa ver", "remover geotag '
        'das fotos". Histórico de buscas.',
    icon: Icons.public,
  );

  // ── Nubank (banco) ────────────────────────────────────────────────────
  static const bankPousada = Evidence(
    id: 'bank_pousada',
    source: 'Nubank',
    label: 'Pousada em Maresias — 21 fev',
    snippet: 'Pousada Maré Mansa, R\$540, véspera do sumiço da "B.".',
    icon: Icons.account_balance_wallet,
    minCase: 3,
  );
  static const bankFlor = Evidence(
    id: 'bank_flor',
    source: 'Nubank',
    label: 'Floricultura em Pinheiros — ontem',
    snippet: 'R\$95 numa floricultura de Pinheiros, ontem. Pra quem?',
    icon: Icons.account_balance_wallet,
    minCase: 4,
  );
  static const bankComissao = Evidence(
    id: 'bank_comissao',
    source: 'Nubank',
    label: 'Comissão de venda',
    snippet: '+R\$7.200 da imobiliária. Renda normal de corretor.',
    icon: Icons.account_balance_wallet,
    herring: true,
  );

  // ── Gravador (áudio) ──────────────────────────────────────────────────
  static const audioRecovered = Evidence(
    id: 'audio_recovered',
    source: 'Gravador',
    label: 'Áudio recuperado da lixeira',
    snippet:
        '"…fica tranquila, eu te busco na rodoviária…" — mas a voz não é a dele. '
        'Outro sotaque, gíria de praia. É o "Theo". Ele muda a voz.',
    icon: Icons.mic,
    minCase: 3,
  );
  static const audioVo = Evidence(
    id: 'audio_vo',
    source: 'Gravador',
    label: 'Áudio pra vó',
    snippet: '"chego no horário vó". Voz normal.',
    icon: Icons.mic,
    herring: true,
  );

  static const all = <Evidence>[
    marinaFlirt, alineExcuse, familiaOculos, familiaLoja, biaChatCut, jorgeWork,
    camilaChatCut, iasminChatCut, unknownNumber,
    rideRodoviaria, rideMoema, rideAirport,
    glassesSelfie, theoSelfie, geotagMaresias, trophyStories, albumBeach,
    profileRafa, profileTheo, profileGui, leticiaMatch,
    clientList, noteCreci, noteRascunho,
    calMaresias, cafeCalendar, calDomingo,
    newsPinheiros, newsMaresias, newsMoema, searchDelete,
    bankPousada, bankFlor, bankComissao,
    audioRecovered, audioVo,
  ];

  static final _byId = {for (final e in all) e.id: e};
  static Evidence byId(String id) => _byId[id]!;
}
