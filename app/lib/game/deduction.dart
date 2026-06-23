/// A case the detective works. They are solved strictly one at a time — the
/// next case stays sealed until the current one's `advances` deduction lands.
class InvestigationCase {
  const InvestigationCase({
    required this.index,
    required this.title,
    required this.question,
  });
  final int index;
  final String title;
  final String question;
}

class Cases {
  Cases._();
  static const list = [
    InvestigationCase(
      index: 1,
      title: 'Caso 1 — A traição',
      question: 'A Aline te pagou pra provar uma coisa só: ele trai?',
    ),
    InvestigationCase(
      index: 2,
      title: 'Caso 2 — O homem de três caras',
      question:
          'Tem fotos dele que não são dele. Por que um corretor precisa de '
          'disfarce?',
    ),
    InvestigationCase(
      index: 3,
      title: 'Caso 3 — As mulheres',
      question:
          'Os nomes da "lista" são reais. Onde elas estão agora?',
    ),
    InvestigationCase(
      index: 4,
      title: 'Caso 4 — A próxima',
      question: 'Tem um café marcado pra depois de amanhã. Com quem?',
    ),
  ];
  static InvestigationCase byIndex(int i) => list[i - 1];
  static int get count => list.length;
}

/// A connection the player must *make themselves*: pin the right fragments,
/// then link them. `requires` is matched exactly against the selected set, so
/// brute-forcing is costly (wrong links burn the battery).
class Deduction {
  const Deduction({
    required this.id,
    required this.caseIndex,
    required this.requires,
    required this.title,
    required this.text,
    this.advances = false,
    this.unlocksAudio = false,
    this.enablesAccusation = false,
  });

  final String id;
  final int caseIndex;
  final Set<String> requires; // evidence ids (exact match)
  final String title;
  final String text;
  final bool advances; // closes the case → opens the next
  final bool unlocksAudio; // recovering the deleted voice note
  final bool enablesAccusation;
}

class Deductions {
  Deductions._();

  static const traicao = Deduction(
    id: 'traicao',
    caseIndex: 1,
    requires: {'marina_flirt', 'aline_excuse'},
    advances: true,
    title: 'Ele trai a Aline',
    text:
        'O flerte com a Marina + os sumiços que não fecham com a agenda. Caso '
        'da Aline: provado. Era pra acabar aqui — mas tem uma pasta de fotos '
        'que não devia existir.',
  );

  static const disfarce = Deduction(
    id: 'disfarce',
    caseIndex: 2,
    requires: {'glasses_selfie', 'familia_oculos'},
    title: 'Os óculos são fantasia',
    text:
        'A avó confirma que ele nunca precisou de grau. A selfie de óculos é '
        'figurino. Isso não é vaidade — é personagem. Procure o resto do elenco.',
  );

  static const personas = Deduction(
    id: 'personas',
    caseIndex: 2,
    requires: {'profile_rafa', 'profile_theo', 'profile_gui'},
    advances: true,
    title: 'Três homens, um aparelho',
    text:
        'Rafa Imóveis, Theo Maré e Gui Mendes logados no mesmo celular. Três '
        'bios, três idades, três fachadas. Um predador organizado.',
  );

  static const lista = Deduction(
    id: 'lista',
    caseIndex: 3,
    requires: {'client_list', 'news_moema'},
    title: 'A "lista de clientes" é uma lista de alvos',
    text:
        'O nome riscado bate com a estudante de Moema. Não são clientes — são '
        'mulheres, com cidade e data. E um campo de status.',
  );

  static const viagens = Deduction(
    id: 'viagens',
    caseIndex: 3,
    unlocksAudio: true,
    requires: {'cal_maresias', 'bank_pousada', 'news_maresias'},
    title: 'As viagens coincidem com os sumiços',
    text:
        'Viagem marcada + pousada paga + a notícia do desaparecimento — tudo no '
        'mesmo fim de semana, na mesma cidade. Não é coincidência três vezes. '
        '(Talvez ele tenha apagado um áudio que não devia.)',
  );

  static const rodoviaria = Deduction(
    id: 'rodoviaria',
    caseIndex: 3,
    requires: {'ride_rodoviaria', 'bia_chat_cut'},
    title: 'Ele buscou a Bia na rodoviária',
    text:
        'A corrida do 99 sai da Rodoviária de Maresias às 19:42, "2 passageiros", '
        'pra pousada que ele pagou. É o "fica no portão 3 que eu" que ficou no ar. '
        'Ele foi a última pessoa a vê-la.',
  );

  static const pinheirosVitima = Deduction(
    id: 'pinheiros_vitima',
    caseIndex: 3,
    requires: {'camila_chat_cut', 'news_pinheiros'},
    title: 'Camila foi a primeira',
    text:
        'A conversa da Camila some no "tô subindo, qual andar?" — num apê que o '
        '"Rafa Imóveis" ia mostrar. Bate com a terapeuta de Pinheiros da notícia. '
        'Oito meses atrás. O começo de tudo.',
  );

  static const moemaVitima = Deduction(
    id: 'moema_vitima',
    caseIndex: 3,
    requires: {'iasmin_chat_cut', 'ride_moema'},
    title: 'A Iasmin foi a última',
    text:
        'A conversa da Iasmin para no "é esse carro prata?". A corrida do 99 sai '
        'de um bar em Moema, de madrugada, "2 passageiros" — na mesma semana. '
        'Duas semanas atrás. O caso ainda está quente.',
  );

  static const voz = Deduction(
    id: 'voz',
    caseIndex: 3,
    advances: true,
    requires: {'bia_chat_cut', 'audio_recovered'},
    title: 'Ele foi quem buscou a Bia',
    text:
        'A conversa dela para no "te busco na rodoviária". O áudio recuperado é '
        'a voz "Theo" dizendo exatamente isso. Ele estava lá. Ele é o último que '
        'a viu.',
  );

  static const proxima = Deduction(
    id: 'proxima',
    caseIndex: 4,
    enablesAccusation: true,
    requires: {'leticia_match', 'cafe_calendar'},
    title: 'Letícia é a próxima',
    text:
        'Match ativo em Pinheiros + café marcado pra depois de amanhã. Ela ainda '
        'está viva. Agora dá pra montar a acusação — e ainda dá tempo.',
  );

  static const all = <Deduction>[
    traicao, disfarce, personas, lista, viagens, rodoviaria, pinheirosVitima,
    moemaVitima, voz, proxima,
  ];

  /// Find the deduction whose recipe matches the selected evidence ids exactly.
  static Deduction? match(Set<String> selected) {
    for (final d in all) {
      if (d.requires.length == selected.length &&
          d.requires.containsAll(selected)) {
        return d;
      }
    }
    return null;
  }

  static List<Deduction> forCase(int caseIndex) =>
      all.where((d) => d.caseIndex == caseIndex).toList();
}
