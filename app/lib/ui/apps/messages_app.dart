import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_state.dart';
import '../widgets.dart';

// WhatsApp dark palette.
const _waHeader = Color(0xFF1F2C34);
const _waBg = Color(0xFF0B141A);
const _waIn = Color(0xFF1F2C34);
const _waOut = Color(0xFF005C4B);
const _waGreen = Color(0xFF25D366);
const _waTick = Color(0xFF53BDEB);
const _waText = Color(0xFFE9EDEF);
const _waDim = Color(0xFF8696A0);

enum MsgKind { text, audio, image }

class _Msg {
  const _Msg(this.text, this.mine, this.time,
      {this.evId, this.system = false, this.kind = MsgKind.text});
  final String text; // audio: duration "0:14" · image: caption
  final bool mine; // Rafael
  final String time;
  final String? evId;
  final bool system;
  final MsgKind kind;
}

class _Thread {
  const _Thread({
    required this.name,
    required this.avatar,
    required this.preview,
    required this.time,
    required this.messages,
    this.unread = 0,
    this.online = false,
    this.archived = false,
    this.group = false,
  });
  final String name;
  final String avatar;
  final String preview;
  final String time;
  final List<_Msg> messages;
  final int unread;
  final bool online;
  final bool archived;
  final bool group;
}

const _threads = <_Thread>[
  _Thread(
    name: 'Aline ❤️',
    avatar: '🌷',
    preview: 'tô em reunião amor, te ligo depois',
    time: '08:55',
    online: true,
    unread: 2,
    messages: [
      _Msg('— vocês conversam há 7 meses', false, '', system: true),
      _Msg('há 7 meses', false, '', system: true),
      _Msg('oi linda 😊 foi muito bom te conhecer ontem. já tô com saudade', true,
          '23:40'),
      _Msg('também adorei ❤️ vc é diferente sabia', false, '23:52'),
      _Msg('diferente bom espero kkk', true, '23:53'),
      _Msg('muito bom 🥰', false, '23:55'),
      _Msg('bom dia 🌅 acordei pensando em vc. dorme mais um pouco vai', true,
          '06:50'),
      _Msg('0:24', true, '06:51', kind: MsgKind.audio),
      _Msg('aaa esse áudio de bom dia 🥹 melhor jeito de acordar', false, '08:09'),
      _Msg('que fofo 🥹 vc sempre acorda cedo assim?', false, '08:10'),
      _Msg('corretor não tem hora amor. mas pra te mandar bom dia eu acordo '
          'sempre', true, '08:11'),
      _Msg('— há 5 meses', false, '', system: true),
      _Msg('amor já tomou o remédio? 💊 não esquece hj', true, '07:12'),
      _Msg('tomei 😘 vc cuida de mim demais', false, '09:38'),
      _Msg('é meu trabalho cuidar de vc ❤️ domingo te levo no almoço da minha vó', true, '09:40'),
      _Msg('serio?? vou conhecer sua família? 🥹', false, '09:41'),
      _Msg('claro. minha vó vai te amar. família é tudo pra mim', true, '09:42'),
      _Msg('to nervosa kkk', false, '09:43'),
      _Msg('relaxa, são gente boa. nipo tradicional, almoço sagrado de domingo', true, '09:44'),
      _Msg('amei o almoço ontem ❤️ sua avó é um amor', false, '14:00'),
      _Msg('nós dois ontem 🥰', false, '14:01', kind: MsgKind.image),
      _Msg('viu? falei. ela já te adotou 😄', true, '14:02'),
      _Msg('guarda essa foto, ficamos lindos', true, '14:03', kind: MsgKind.image),
      _Msg('— há 3 meses', false, '', system: true),
      _Msg('vc viu meu story com o pessoal do trabalho?', false, '20:01'),
      _Msg('vi. quem é aquele cara do teu lado?', true, '20:05'),
      _Msg('o Pedro? colega de design amor kkk', false, '20:06'),
      _Msg('hm. ele tava bem coladinho em vc', true, '20:07'),
      _Msg('ciumento 🙄 é só colega', false, '20:08'),
      _Msg('desculpa. é que eu te amo demais, não quero te perder', true, '20:10'),
      _Msg('vc não vai me perder bobo ❤️', false, '20:11'),
      _Msg('melhor evitar postar com outros caras né? gera confusão à toa', true, '20:13'),
      _Msg('ata... tá', false, '20:20'),
      _Msg('— há 1 mês', false, '', system: true),
      _Msg('amor cadê vc? a gente ia almoçar hj', false, '13:30'),
      _Msg('surgiu uma visita de imóvel de última hora, desculpa 😞', true, '14:10'),
      _Msg('vc some todo fim de semana ultimamente', false, '14:11'),
      _Msg('é a correria amor. tô construindo um futuro pra gente', true, '14:12'),
      _Msg('tô me sentindo sozinha rafa', false, '14:15'),
      _Msg('não fala isso 🥺 vc é tudo pra mim. semana que vem só nós dois, juro', true, '14:16'),
      _Msg('— este fim de semana', false, '', system: true),
      _Msg('bom diaaa meu amor, já tomou o remédio? 💊', true, '07:12'),
      _Msg('tomei sim ❤️ e você, dormiu bem?', false, '09:38'),
      _Msg('dormi pensando em vc 🥰 hj fica difícil, plantão de venda', true, '09:40'),
      _Msg('de novo sábado? a gente ia jantar na Benedito', false, '18:22'),
      _Msg('eu sei, me desculpa. esse cliente tá pegando meu fds inteiro', true,
          '23:02'),
      _Msg('vc tá viajando de novo? vi que seu carro não tá na garagem', false, '23:00'),
      _Msg('rafa são 23h e você ainda tá em "reunião"', false, '23:03',
          evId: 'aline_excuse'),
      _Msg('boa noite minha vida, te amo. domingo é nosso, prometo', true,
          '03:17'),
      _Msg('3:17 da manhã??', false, '08:55'),
      _Msg('que reunião termina 3h da manhã rafa', false, '08:55'),
      _Msg('tô em reunião amor, te ligo depois', true, '08:56'),
    ],
  ),
  _Thread(
    name: 'Marina (trampo)',
    avatar: '💼',
    preview: 'ontem foi bom demais 😏',
    time: '21:41',
    unread: 0,
    messages: [
      _Msg('oi sumida, tudo bem por aí?', true, '18:30'),
      _Msg('oi vc kkk tudo. e o trabalho?', false, '18:45'),
      _Msg('corrido. mas sempre dá um tempo pra vc 😉', true, '18:46'),
      _Msg('safado', false, '18:47'),
      _Msg('vc tá livre quinta? penso num lugar tranquilo, só nós dois', true, '19:00'),
      _Msg('posso sim. mas e a sua namorada?', false, '19:05'),
      _Msg('complicado isso. a gente tá meio no fim, sabe', true, '19:06'),
      _Msg('sei... todo mundo fala isso kkkk', false, '19:07'),
      _Msg('comigo é diferente. confia', true, '19:08'),
      _Msg('— ontem', false, '', system: true),
      _Msg('oi sumida de novo kkk', true, '21:30'),
      _Msg('tudo, ainda pensando em ontem 🙈', false, '21:33'),
      _Msg('ontem foi bom demais 😏 semana que vem de novo?', false, '21:34',
          evId: 'marina_flirt'),
      _Msg('com certeza. mesmo lugar? haha', true, '21:36'),
      _Msg('pode ser. vc me deixa meio doida sabia', false, '21:38'),
      _Msg('o sentimento é mútuo 😏', true, '21:39'),
      _Msg('e a tal da namorada, hein', false, '21:40'),
      _Msg('relaxa, isso é só questão de tempo', true, '21:41'),
      _Msg('vc fala isso mas nunca termina kkk', false, '21:42'),
      _Msg('umas coisas precisam ser no tempo certo. confia em mim', true, '21:43'),
    ],
  ),
  _Thread(
    name: 'Almoço de Domingo 🍱',
    avatar: '🍱',
    group: true,
    preview: 'Vó: tira esses óculos de mentira menino 🤣',
    time: '10:11',
    unread: 5,
    messages: [
      _Msg('— Mãe adicionou Vó ao grupo', false, '', system: true),
      _Msg('bom dia minha família linda ☀️', false, '08:30'),
      _Msg('bom dia mãe ❤️', true, '08:45'),
      _Msg('Vó: bom dia meus amores 🙏', false, '09:00'),
      _Msg('vó a senhora dormiu bem? tomou o remédio da pressão?', true, '09:02'),
      _Msg('Vó: tomei sim meu anjo. que neto cuidadoso 🥹', false, '09:05'),
      _Msg('quem vai no almoço hj? fiz yakisoba', false, '09:30'),
      _Msg('eu vou! tô morrendo de saudade da comida da senhora', true, '09:40'),
      _Msg('chego 12h vó, comprei o doce que a senhora gosta 🥮', true, '10:02'),
      _Msg('que neto abençoado 🙏', false, '10:05'),
      _Msg('Tio Sergio: traz a namorada nova? kkk', false, '10:05'),
      _Msg('hj não tio, ela tá viajando com a família dela', true, '10:06'),
      _Msg('mãe, emoldurei a foto da inauguração da loja do vô — 1962, na '
          'Liberdade. fica linda na sala', true, '10:06', evId: 'familia_loja'),
      _Msg('ficou assim ó 👇', true, '10:06', kind: MsgKind.image),
      _Msg('Vó: ai meu Toshiro... que saudade da loja 🥹 1962, quanta história', false, '10:07'),
      _Msg('Vó: 0:38', false, '10:07', kind: MsgKind.audio),
      _Msg('você é o nosso orgulho, filho ❤️ continua honrando o nome', false, '10:08'),
      _Msg('sempre mãe. a senhora me criou bem 🙏', true, '10:09'),
      _Msg('menino, e essa foto sua de óculos no instagram? você nunca precisou '
          'de grau na vida 🤣 tira isso', false, '10:10', evId: 'familia_oculos'),
      _Msg('é coisa de trabalho vó 😅 marketing', true, '10:11'),
      _Msg('Vó: marketing kkk no meu tempo era só sorrir pro freguês', false, '10:12'),
      _Msg('Tio Sergio: kkkkk essa vó', false, '10:13'),
      _Msg('amo vcs ❤️ daqui a pouco tô aí', true, '10:15'),
    ],
  ),
  _Thread(
    name: 'Jorge Corretor',
    avatar: '🏢',
    preview: 'comissão cai dia 15, abraço',
    time: 'ontem',
    messages: [
      _Msg('e aí Rafa, fechou o apê da Vila Olímpia?', false, '14:02'),
      _Msg('fechou! casal jovem, pagaram à vista', true, '14:10'),
      _Msg('maravilha. comissão cai dia 15, abraço', false, '14:11'),
    ],
  ),
  _Thread(
    name: 'Mãe',
    avatar: '👩',
    preview: 'leva um casaco que tá frio',
    time: 'ontem',
    messages: [
      _Msg('filho, vai viajar de novo esse fim de semana?', false, '19:00'),
      _Msg('vou mãe, uns dias respirar. trabalho cansa', true, '19:05'),
      _Msg('leva um casaco que tá frio na serra ❤️', false, '19:06'),
      _Msg('e come direito! não fica só de marmita', false, '19:06'),
      _Msg('pode deixar 😘 domingo te levo o doce', true, '19:10'),
      _Msg('a vó perguntou de vc hoje', false, '19:12'),
      _Msg('falo com ela todo dia 🥹', true, '19:13'),
      _Msg('eu sei, ela só sente saudade', false, '19:14'),
      _Msg('logo passo aí mãe', true, '19:15'),
      _Msg('seu pai mandou abraço', false, '19:20'),
      _Msg('manda de volta ❤️', true, '19:21'),
      _Msg('ah, achei aquele paletó seu aqui em casa', false, '19:30'),
      _Msg('deixa que pego domingo', true, '19:31'),
      _Msg('tá magro, tá comendo?', false, '19:32'),
      _Msg('to sim mãe 😅 academia', true, '19:33'),
      _Msg('toma cuidado nessas estradas viu', false, '19:40'),
      _Msg('sempre tomo 🙏', true, '19:41'),
    ],
  ),
  _Thread(
    name: 'Pelada de Quinta ⚽',
    avatar: '⚽',
    group: true,
    preview: 'Marcão: confirma quem vai hj',
    time: '18:40',
    unread: 12,
    messages: [
      _Msg('— Marcão adicionou você', false, '', system: true),
      _Msg('fala rapaziada, confirma quem vai hj 21h', false, '17:02'),
      _Msg('to dentro 🙋', false, '17:05'),
      _Msg('eu tbm', false, '17:06'),
      _Msg('boooora', false, '17:06'),
      _Msg('eu não vou conseguir hj, tenho visita de imóvel', true, '17:10'),
      _Msg('de novo Rafa kkkk vc some toda quinta', false, '17:11'),
      _Msg('corretor não tem hora chefe 😂', true, '17:12'),
      _Msg('esse aí só aparece pra cobrar a vaquinha kkkk', false, '17:13'),
      _Msg('mentira eu jogo bem 😤', true, '17:14'),
      _Msg('joga bem de boca kkkkk', false, '17:15'),
      _Msg('chora não craque 🤣', true, '17:16'),
      _Msg('faltou pagar a quadra do mês ainda hein', false, '17:30'),
      _Msg('pix depois eu mando', true, '17:31'),
      _Msg('todo mês a mesma história 🙄', false, '17:32'),
      _Msg('mandei agora ó 💸', true, '17:35'),
      _Msg('caiu, valeu', false, '17:36'),
      _Msg('quem tá levando bola?', false, '18:00'),
      _Msg('a minha tá murcha', false, '18:01'),
      _Msg('o Téo leva sempre', false, '18:02'),
      _Msg('alguém leva colete?', false, '18:40'),
      _Msg('eu levo os coletes', false, '18:41'),
      _Msg('lembra de levar água tbm, tá calor', false, '18:42'),
      _Msg('e o churras depois? bora?', false, '19:00'),
      _Msg('boraaa 🍺🍖', false, '19:01'),
      _Msg('eu fico devendo o churras, vou viajar amanhã cedo', true, '19:05'),
      _Msg('VIAJAR DE NOVO kkkkkkk esse cara vive de férias', false, '19:06'),
      _Msg('é trabalho 😅', true, '19:07'),
      _Msg('sei sei', false, '19:08'),
      _Msg('time hj: eu, marcão, téo, lipe, gordo e o vitor. 6 já dá', false, '20:10'),
      _Msg('o gordo furou', false, '20:30'),
      _Msg('óbvio kkkk', false, '20:31'),
      _Msg('alguém chama mais um', false, '20:32'),
    ],
  ),
  _Thread(
    name: 'Personal Rodrigo 💪',
    avatar: '🏋️',
    preview: 'treino de perna amanhã não falta',
    time: '07:30',
    unread: 2,
    messages: [
      _Msg('bom dia! treino de perna amanhã, não falta', false, '07:30'),
      _Msg('amanhã não dá, viajando. semana que vem dobro', true, '07:45'),
      _Msg('vc viaja demais hein 😅 manda foto do shape', false, '07:46'),
      _Msg('kkk depois mando', true, '07:47'),
      _Msg('tá tomando a creatina certinho?', false, '08:00'),
      _Msg('todo dia 💪', true, '08:01'),
      _Msg('e o whey, acabou?', false, '08:02'),
      _Msg('acabou, vou comprar', true, '08:03'),
      _Msg('compra aquele do link que te mandei, tá em promo', false, '08:04'),
      _Msg('fechou', true, '08:05'),
      _Msg('lembra: descanso tbm é treino. dorme bem', false, '08:30'),
      _Msg('esse fim de semana vou dormir pouco kkk viagem', true, '08:31'),
      _Msg('relaxa no álcool então 🍺❌', false, '08:32'),
    ],
  ),
  _Thread(
    name: 'Condomínio Aurora 🏢',
    avatar: '🏢',
    group: true,
    preview: 'Síndico: encomenda na portaria',
    time: 'ontem',
    unread: 4,
    messages: [
      _Msg('Síndico: Prezados, a obra do 4º andar começa segunda', false, '09:00'),
      _Msg('Dona Marlene 502: de novo barulho? semana passada foi terrível', false, '09:12'),
      _Msg('Síndico: infelizmente é reforma autorizada, das 8h às 17h', false, '09:15'),
      _Msg('Dona Marlene 502: um absurdo isso', false, '09:16'),
      _Msg('Seu Otávio 71: gente alguém deixou o portão da garagem aberto ontem', false, '10:00'),
      _Msg('Síndico: por favor fechem o portão, questão de segurança 🙏', false, '10:05'),
      _Msg('Dona Marlene 502: e o cachorro do 302 latindo a noite toda', false, '10:30'),
      _Msg('Morador 302: ele é idoso, peço paciência', false, '10:35'),
      _Msg('Síndico: vamos manter o respeito no grupo pessoal', false, '10:40'),
      _Msg('lembrando que a piscina fecha pra limpeza quinta', false, '11:00'),
      _Msg('Seu Otávio 71: e a taxa extra do elevador, quando vence?', false, '11:30'),
      _Msg('Síndico: dia 10, boleto no e-mail', false, '11:31'),
      _Msg('Sr. Rafael, tem encomenda na portaria desde sexta', false, '14:20'),
      _Msg('valeu, pego quando voltar de viagem', true, '14:25'),
      _Msg('Síndico: ok, guardamos aqui', false, '14:26'),
      _Msg('Dona Marlene 502: alguém sabe um bom encanador?', false, '16:00'),
      _Msg('Seu Otávio 71: tenho um contato, te passo', false, '16:10'),
    ],
  ),
  _Thread(
    name: 'Dra. Helena (dentista)',
    avatar: '🦷',
    preview: 'confirmando sua limpeza',
    time: 'seg',
    messages: [
      _Msg('Olá! Confirmando sua limpeza quinta 16h 🦷', false, '11:00'),
      _Msg('pode confirmar', true, '11:30'),
      _Msg('Perfeito, até lá!', false, '11:31'),
    ],
  ),
  _Thread(
    name: 'Vivo',
    avatar: '📵',
    preview: 'Sua fatura já está disponível',
    time: 'seg',
    messages: [
      _Msg('Sua fatura Vivo de R\$ 119,90 já está disponível.', false, '08:00'),
      _Msg('Aproveite: dobro de internet por +R\$10/mês!', false, '08:00'),
    ],
  ),
  _Thread(
    name: 'Lucas',
    avatar: '🍺',
    preview: 'bora um happy hour sexta?',
    time: '22:15',
    unread: 1,
    messages: [
      _Msg('e aí sumido, vivo ou morto?', false, '22:00'),
      _Msg('vivíssimo kkk corrido demais', true, '22:05'),
      _Msg('tá rolando uns rolê bom hein, vc tá perdendo', false, '22:06'),
      _Msg('imagino kkk como tá a galera?', true, '22:07'),
      _Msg('todo mundo bem. o Gordo casou, acredita?', false, '22:08'),
      _Msg('NÃO acredito kkkkk aquele cara?', true, '22:09'),
      _Msg('pois é, tá até mais magro', false, '22:10'),
      _Msg('o amor transforma né 😂', true, '22:11'),
      _Msg('e vc, namorando firme?', false, '22:12'),
      _Msg('mais ou menos, tô levando 😏', true, '22:13'),
      _Msg('safado kkk sempre foi assim', false, '22:14'),
      _Msg('bora um happy hour sexta?', false, '22:15'),
      _Msg('sexta tô fora de SP, fica pra outra', true, '22:16'),
      _Msg('mano vc nunca tá em SP ultimamente 😂', false, '22:17'),
      _Msg('é a vida de corretor, tem que rodar', true, '22:18'),
      _Msg('roda mais que Uber kkkk', false, '22:19'),
      _Msg('kkkk veio', true, '22:20'),
      _Msg('mas marca aí qualquer dia, faz tempo', false, '22:21'),
      _Msg('marco sim, semana que vem te chamo', true, '22:22'),
      _Msg('falou 🍺', false, '22:23'),
      _Msg('vc fala isso e some de novo né 😅', false, '22:30'),
    ],
  ),
  _Thread(
    name: 'Família Andrade 🇯🇵',
    avatar: '🍣',
    group: true,
    preview: 'Tia Yuki: feliz aniversário pro Rafa 🎂',
    time: 'dom',
    unread: 9,
    messages: [
      _Msg('bom dia família abençoada 🙏', false, '08:00'),
      _Msg('Tia Yuki: feliz aniversário atrasado pro Rafa 🎂', false, '08:05'),
      _Msg('Tio Sergio: parabéns sobrinho! saúde 🍻', false, '08:06'),
      _Msg('Prima Lia: parabéns priminho ❤️🎉', false, '08:07'),
      _Msg('Vovó: que Deus te abençoe meu neto 🙏', false, '08:08'),
      _Msg('obrigado tia ❤️ saudades de todos', true, '08:10'),
      _Msg('quando vem aqui em Suzano?', false, '08:11'),
      _Msg('logo logo, prometo. trabalho tá louco', true, '08:12'),
      _Msg('Tia Yuki: trabalha demais esse menino', false, '08:13'),
      _Msg('Vovó: meu neto trabalhador 🥹', false, '08:20'),
      _Msg('Tio Sergio: e a namorada nova? traz pra conhecer', false, '08:25'),
      _Msg('Tia Yuki: ééé queremos conhecer 👀', false, '08:26'),
      _Msg('calma gente kkk ainda é cedo', true, '08:30'),
      _Msg('Prima Lia: ele sempre foge dessa pergunta kkkk', false, '08:31'),
      _Msg('Vovó: no meu tempo já tava casado 😄', false, '08:32'),
      _Msg('Tia Yuki: kkkkk vó', false, '08:33'),
      _Msg('Primo Téo: deixa o cara vó, ele é garanhão 😎', false, '08:40'),
      _Msg('Tio Sergio: HAHAHA', false, '08:41'),
      _Msg('para Téo 🤣 nada disso', true, '08:42'),
      _Msg('Prima Lia: alguém viu a receita de yakisoba que mandei?', false, '09:00'),
      _Msg('Tia Yuki: vi sim, vou fazer domingo', false, '09:05'),
      _Msg('Vovó: ninguém faz igual eu 😌', false, '09:06'),
      _Msg('verdade vó, a sua é a melhor 🥹', true, '09:10'),
      _Msg('Primo Téo: bora jogar bola domingo antes do almoço', false, '10:00'),
      _Msg('Tio Sergio: bora! levo a bola', false, '10:01'),
      _Msg('domingo eu tô viajando, fica pra próxima 😔', true, '10:05'),
      _Msg('Primo Téo: vc vive viajando hein primo kkk', false, '10:06'),
      _Msg('Vovó: cuida pra não cansar demais meu anjo', false, '10:07'),
    ],
  ),
  _Thread(
    name: 'Imobiliária Prime 🏘️',
    avatar: '🏘️',
    group: true,
    preview: 'meta do mês fechada, parabéns time',
    time: 'sex',
    messages: [
      _Msg('Gerente: Bom dia time! Meta do mês batida 🎉', false, '09:00'),
      _Msg('parabéns pessoal!', true, '09:10'),
      _Msg('Gerente: Rafa foi o destaque de novo 👏', false, '09:11'),
      _Msg('Cláudia: esse Rafa não erra um fechamento 👏', false, '09:12'),
      _Msg('é sorte kkk', true, '09:13'),
      _Msg('Cláudia: sorte nada, lábia 😂', false, '09:14'),
      _Msg('Gerente: aproveitem, lançamento novo na Vila Mariana', false, '10:00'),
      _Msg('Jorge: já tenho 2 clientes interessados', false, '10:05'),
      _Msg('Gerente: isso! quem quer as chaves pra visita?', false, '10:06'),
      _Msg('eu pego, faço as visitas do fds', true, '10:10'),
      _Msg('Cláudia: vc trabalha até no fds? que máquina', false, '10:11'),
      _Msg('cliente bom não espera 😌', true, '10:12'),
      _Msg('Gerente: por isso é o destaque kkk', false, '10:13'),
      _Msg('Jorge: alguém viu a papelada do apê da Vila Olímpia?', false, '14:00'),
      _Msg('tá comigo, levo segunda', true, '14:05'),
      _Msg('Gerente: reunião segunda 9h não esqueçam', false, '17:00'),
      _Msg('Cláudia: anotado 📝', false, '17:05'),
    ],
  ),
  _Thread(
    name: 'Renata',
    avatar: '🌻',
    preview: 'oi, tudo bem? faz tempo né',
    time: '4 dias',
    messages: [
      _Msg('oi Rafa, tudo bem? faz tempo né', false, '20:00'),
      _Msg('oi Renata! tudo e vc?', true, '20:30'),
      _Msg('tudo. só lembrei de vc, vi um apê e pensei em pedir indicação', false, '20:31'),
      _Msg('claro, te passo uns contatos 👍', true, '20:35'),
      _Msg('vc continua no ramo de imóveis então', false, '20:36'),
      _Msg('sempre, virei referência kkk', true, '20:37'),
      _Msg('que bom 🙂 e a vida amorosa?', false, '20:38'),
      _Msg('ocupado demais pra isso 😅', true, '20:40'),
      _Msg('sei... vc sempre foi um mistério', false, '20:41'),
      _Msg('haha que isso', true, '20:42'),
      _Msg('enfim, me manda os contatos quando puder', false, '20:45'),
      _Msg('mando amanhã, tô saindo agora', true, '20:46'),
      _Msg('tranquilo, obrigada 🌻', false, '20:47'),
    ],
  ),
  _Thread(
    name: 'Santander',
    avatar: '🏦',
    preview: 'Detectamos um acesso à sua conta',
    time: '3 dias',
    messages: [
      _Msg('Detectamos um novo acesso. Foi você?', false, '15:00'),
      _Msg('Não compartilhe seus dados. Equipe Santander.', false, '15:00'),
    ],
  ),
  _Thread(
    name: 'Marquinhos 🎣',
    avatar: '🎣',
    preview: 'pescaria em Ilhabela vem?',
    time: '5 dias',
    messages: [
      _Msg('mano, pescaria em Ilhabela mês que vem, vem?', false, '12:00'),
      _Msg('litoral de novo? kkk to sempre lá', true, '12:30'),
      _Msg('vc conhece cada canto do litoral hein', false, '12:31'),
      _Msg('trabalho me leva 🤷', true, '12:32'),
      _Msg('vai ser top, aluguei um barco', false, '12:40'),
      _Msg('quantos vão?', true, '12:41'),
      _Msg('uns 6. leva a vara boa', false, '12:42'),
      _Msg('a minha quebrou na última 😅', true, '12:43'),
      _Msg('kkk vc não cuida das coisas', false, '12:44'),
      _Msg('compro outra antes', true, '12:45'),
      _Msg('mete a do meio que é melhor pra robalo', false, '12:46'),
      _Msg('anotado capitão 🎣', true, '12:47'),
      _Msg('confirma até dia 20 que aí fecho o barco', false, '13:00'),
      _Msg('confirmo, deixa eu ver a agenda', true, '13:01'),
      _Msg('vc e essa agenda lotada kkk', false, '13:02'),
    ],
  ),
  _Thread(
    name: 'Farmácia Pague Menos',
    avatar: '💊',
    preview: 'seu pedido está pronto p/ retirada',
    time: '6 dias',
    messages: [
      _Msg('Seu pedido está pronto para retirada 💊', false, '10:00'),
      _Msg('Programa fidelidade: você tem 240 pontos.', false, '10:00'),
    ],
  ),
  _Thread(
    name: 'iFood Entregador',
    avatar: '🛵',
    preview: 'cheguei, tô na portaria',
    time: '1 sem',
    messages: [
      _Msg('boa noite, cheguei, tô na portaria', false, '21:10'),
      _Msg('desço já', true, '21:11'),
      _Msg('beleza 👍', false, '21:11'),
    ],
  ),
  _Thread(
    name: 'iFood',
    avatar: '🛵',
    preview: 'Seu pedido saiu para entrega 🎉',
    time: 'ter',
    messages: [
      _Msg('— mensagens automáticas', false, '', system: true),
      _Msg('Pedido confirmado: Temakeria Liberdade', false, '20:01'),
      _Msg('Seu pedido saiu para entrega 🎉', false, '20:28'),
    ],
  ),
  _Thread(
    name: '+55 11 9____-____',
    avatar: '❓',
    preview: 'eu sei o que você fez com elas',
    time: 'sex',
    unread: 1,
    messages: [
      _Msg('— número não salvo', false, '', system: true),
      _Msg('eu sei o que você fez com elas', false, '23:51',
          evId: 'unknown_number'),
      _Msg('😂 quem é vc', true, '23:55'),
      _Msg('— você bloqueou este contato', false, '', system: true),
    ],
  ),
  _Thread(
    name: 'B.',
    avatar: '🏄‍♀️',
    archived: true,
    preview: '[arquivada]',
    time: '4 meses',
    messages: [
      _Msg('— conversa arquivada • sem atividade há 4 meses', false, '',
          system: true),
      _Msg('oi Theo! vi que vc surfa também, que praia vc curte?', false, '—'),
      _Msg('maresias é minha vida 🏄 mas pego onda em qualquer canto', true, '—'),
      _Msg('aaa amo maresias! moro aqui kkk', false, '—'),
      _Msg('sério?? que destino é esse 😍 a gente tem que surfar junto', true, '—'),
      _Msg('bora! vc é daqui da região?', false, '—'),
      _Msg('nasci em SP mas minha alma é praiana. e tem mais:', true, '—'),
      _Msg('nossa minha família também é de Okinawa, que coincidência 🥹', true,
          '—'),
      _Msg('SÉRIO?? para! a gente tem MUITA coisa pra conversar', false, '—'),
      _Msg('viu? era pra gente se conhecer mesmo 😌 o universo conspira', true, '—'),
      _Msg('to rindo aqui kkk vc é muito gente boa', false, '—'),
      _Msg('vc é especial Bia. sério. raro encontrar alguém assim', true, '—'),
      _Msg('🥹 vc também', false, '—'),
      _Msg('me conta, vc costuma sair sozinha? tipo viajar, essas coisas', true, '—'),
      _Msg('às vezes! sou meio aventureira kkk minha mãe vive preocupada', false, '—'),
      _Msg('kkk mãe é assim. mas adulto tem que viver né', true, '—'),
      _Msg('bora marcar então! quando vc vem pra cá?', false, '—'),
      _Msg('que tal eu ir aí sexta? te busco na rodoviária, te levo num lugar '
          'que só quem é de Okinawa conhece 😉', true, '—'),
      _Msg('amei demais. chego 19h, ônibus de Maresias', false, '—'),
      _Msg('combinado. vai ser inesquecível. não conta pra ninguém, quero te '
          'fazer uma surpresa 🤫', true, '—'),
      _Msg('aiii que fofo 🥹 não conto', false, '—'),
      _Msg('fica no portão 3 que eu te encontro', true, '—'),
      _Msg('tô chegando, fica no portão 3 que eu te', false, '—',
          evId: 'bia_chat_cut'),
    ],
  ),
  _Thread(
    name: 'Camila',
    avatar: '🧘‍♀️',
    archived: true,
    preview: '[arquivada]',
    time: '8 meses',
    messages: [
      _Msg('— conversa arquivada • sem atividade há 8 meses', false, '',
          system: true),
      _Msg('oi Camila, tudo bem? aqui é o Rafa, do app 😊', true, '—'),
      _Msg('oi Rafa! tudo e vc?', false, '—'),
      _Msg('ótimo. vi que vc é terapeuta, que área linda. ajuda tanta gente', true, '—'),
      _Msg('ai obrigada 🥰 amo o que faço', false, '—'),
      _Msg('eu trabalho com imóveis, inclusive. vc não tá procurando um lugar '
          'pro consultório?', true, '—'),
      _Msg('nossa, na verdade tô sim! mas tá difícil achar', false, '—'),
      _Msg('deixa comigo 😌 conheço Pinheiros inteiro. acho o lugar perfeito pra vc', true, '—'),
      _Msg('vc é meu anjo kkk', false, '—'),
      _Msg('— uns dias depois', false, '', system: true),
      _Msg('Camila! achei um apê perfeito pro seu consultório, Pinheiros 😊 '
          'silencioso, luz natural, sua cara', true, '—'),
      _Msg('aaai que vontade. quando dá pra ver?', false, '—'),
      _Msg('hoje mesmo se quiser. é desocupado, tenho a chave', true, '—'),
      _Msg('perfeito! me passa o endereço', false, '—'),
      _Msg('te mando agora. sobe que te encontro lá em cima, tô subindo o café', true, '—'),
      _Msg('vc pensa em tudo né 🥹 fechou! tô indo', false, '—'),
      _Msg('tô subindo, qual andar?', false, '—', evId: 'camila_chat_cut'),
    ],
  ),
  _Thread(
    name: 'Iasmin',
    avatar: '⚖️',
    archived: true,
    preview: '[arquivada]',
    time: '2 semanas',
    messages: [
      _Msg('— conversa arquivada • sem atividade há 2 semanas', false, '',
          system: true),
      _Msg('oi Iasmin! gostei muito do seu perfil. estudante de Direito né? '
          'inteligência me atrai 😏', true, '—'),
      _Msg('kkk oi Gui! é sim, último ano. e vc é coach?', false, '—'),
      _Msg('isso, wellness. mente sã, corpo são 💪 vc cuida da saúde mental, '
          'eu do resto haha', true, '—'),
      _Msg('combinamos então kkk', false, '—'),
      _Msg('bora marcar? conheço um bar incrível em Moema, escondido, poucos '
          'conhecem', true, '—'),
      _Msg('amo lugar escondido! pode ser sexta', false, '—'),
      _Msg('fechado. eu te busco, mais seguro do que vc ir sozinha de madrugada', true, '—'),
      _Msg('nossa que cavalheiro 🥹', false, '—'),
      _Msg('é só cuidado. cidade perigosa pra mulher sozinha', true, '—'),
      _Msg('Vou de vestido então 💃 te aviso quando sair', false, '—'),
      _Msg('te espero. vou de carro, vc reconhece fácil', true, '—'),
      _Msg('tô te esperando na esquina, é esse carro prata?', false, '—',
          evId: 'iasmin_chat_cut'),
    ],
  ),
];

class MessagesApp extends StatelessWidget {
  const MessagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final active = _threads.where((t) => !t.archived).toList();
    final archived = _threads.where((t) => t.archived).toList();
    return AppShell(
      headerColor: _waHeader,
      headerFg: _waText,
      title: 'WhatsApp',
      actions: [
        Icon(Icons.search, color: _waText),
        const SizedBox(width: 18),
        Icon(Icons.more_vert, color: _waText),
      ],
      body: Container(
        color: _waBg,
        child: ListView(
          children: [
            if (archived.isNotEmpty)
              ListTile(
                leading: Icon(Icons.archive_outlined, color: _waDim),
                title: Text('Arquivadas',
                    style: TextStyle(color: _waText, fontSize: 14)),
                trailing: Text('${archived.length}',
                    style: TextStyle(color: _waGreen, fontSize: 13)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => _ArchivedList(threads: archived))),
              ),
            for (final t in active) _ThreadTile(thread: t, read: g.isThreadRead(t.name)),
          ],
        ),
      ),
    );
  }
}

class _ArchivedList extends StatelessWidget {
  const _ArchivedList({required this.threads});
  final List<_Thread> threads;
  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    return AppShell(
      headerColor: _waHeader,
      headerFg: _waText,
      title: 'Arquivadas',
      body: Container(
        color: _waBg,
        child: ListView(
          children: [
            for (final t in threads)
              _ThreadTile(thread: t, read: g.isThreadRead(t.name)),
          ],
        ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({required this.thread, required this.read});
  final _Thread thread;
  final bool read;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<GameState>().markThreadRead(thread.name);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => _ChatScreen(thread: thread)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
                radius: 26,
                backgroundColor: _waIn,
                child: Text(thread.avatar, style: const TextStyle(fontSize: 22))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(thread.name,
                      style: TextStyle(
                          color: _waText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(thread.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _waDim, fontSize: 13.5)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(thread.time,
                    style: TextStyle(
                        color: thread.unread > 0 && !read ? _waGreen : _waDim,
                        fontSize: 12)),
                const SizedBox(height: 6),
                if (thread.unread > 0 && !read)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    decoration: const BoxDecoration(
                        color: _waGreen, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Center(
                      child: Text('${thread.unread}',
                          style: const TextStyle(
                              color: Color(0xFF0B141A),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
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

class _ChatScreen extends StatelessWidget {
  const _ChatScreen({required this.thread});
  final _Thread thread;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      headerColor: _waHeader,
      headerFg: _waText,
      title: thread.name,
      titleWidget: Row(
        children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: _waIn,
              child: Text(thread.avatar, style: const TextStyle(fontSize: 16))),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(thread.name,
                  style: TextStyle(
                      color: _waText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              Text(thread.online ? 'online' : 'visto por último hoje',
                  style: TextStyle(color: _waDim, fontSize: 11.5)),
            ],
          ),
        ],
      ),
      actions: [
        Icon(Icons.videocam, color: _waText),
        const SizedBox(width: 18),
        Icon(Icons.call, color: _waText),
      ],
      body: Container(
        color: _waBg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          children: [
            for (final m in thread.messages)
              if (m.system)
                _SystemLine(text: m.text)
              else
                _Bubble(msg: m),
          ],
        ),
      ),
    );
  }
}

class _SystemLine extends StatelessWidget {
  const _SystemLine({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: _waIn, borderRadius: BorderRadius.circular(8)),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(color: _waDim, fontSize: 12)),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameState>();
    final pinned = msg.evId != null && g.isPinned(msg.evId!);
    return Align(
      alignment: msg.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: msg.kind == MsgKind.image
            ? () => Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => _ImageViewer(caption: msg.text)))
            : null,
        onLongPress: msg.evId == null
            ? null
            : () {
                if (!g.evidenceAvailable(msg.evId!)) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 1300),
                        backgroundColor: _waIn,
                        content: Text(
                            'Você guarda essa frase na cabeça — mas ainda não '
                            'sabe pra onde ela aponta.',
                            style: TextStyle(color: _waText))));
                  return;
                }
                g.togglePin(msg.evId!);
              },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
          constraints: const BoxConstraints(maxWidth: 270),
          decoration: BoxDecoration(
            color: msg.mine ? _waOut : _waIn,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomLeft: Radius.circular(msg.mine ? 10 : 2),
              bottomRight: Radius.circular(msg.mine ? 2 : 10),
            ),
            border: pinned
                ? Border.all(color: const Color(0xFFE5484D), width: 1.4)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              switch (msg.kind) {
                MsgKind.audio => _AudioBubble(duration: msg.text, mine: msg.mine),
                MsgKind.image => _ImageBubble(caption: msg.text),
                MsgKind.text => Text(msg.text,
                    style: const TextStyle(
                        color: _waText, fontSize: 14.5, height: 1.3)),
              },
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (pinned) ...[
                    const Icon(Icons.push_pin,
                        size: 11, color: Color(0xFFE5484D)),
                    const SizedBox(width: 4),
                  ],
                  Text(msg.time, style: TextStyle(color: _waDim, fontSize: 10.5)),
                  if (msg.mine) ...[
                    const SizedBox(width: 3),
                    const Icon(Icons.done_all, size: 14, color: _waTick),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// WhatsApp-style voice note: play button, fake waveform, duration.
class _AudioBubble extends StatelessWidget {
  const _AudioBubble({required this.duration, required this.mine});
  final String duration;
  final bool mine;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Icon(Icons.play_arrow, color: _waText, size: 26),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < 26; i++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.6),
                        height: 3 + (i * 7 % 13).toDouble(),
                        decoration: BoxDecoration(
                          color: _waDim,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(duration, style: TextStyle(color: _waDim, fontSize: 11)),
        ],
      ),
    );
  }
}

/// Fullscreen photo viewer (tap an image bubble). Black backdrop, big image,
/// caption + faux EXIF line at the bottom — the same language as the Fotos app.
class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.caption});
  final String caption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Foto', style: TextStyle(fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2A3942), Color(0xFF111B21)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Icon(Icons.image, color: Color(0xFF8696A0), size: 90),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption.isNotEmpty)
                  Text(caption,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, height: 1.3)),
                const SizedBox(height: 6),
                const Text('iPhone · f/1.8 · sem geotag',
                    style: TextStyle(color: Color(0xFF8696A0), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// WhatsApp-style image attachment: a gradient placeholder + optional caption.
class _ImageBubble extends StatelessWidget {
  const _ImageBubble({required this.caption});
  final String caption;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 130,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A3942), Color(0xFF111B21)]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: _waDim, size: 40),
        ),
        if (caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: SizedBox(
              width: 200,
              child: Text(caption,
                  style: const TextStyle(
                      color: _waText, fontSize: 14, height: 1.3)),
            ),
          ),
      ],
    );
  }
}
