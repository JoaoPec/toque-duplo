import 'dart:async';

import 'package:flutter/foundation.dart';

import 'deduction.dart';
import 'evidence.dart';

enum GamePhase { briefing, playing, solved, failed }

/// Result of attempting to connect a set of pinned fragments.
enum ConnectResult { linked, none, already, needPin }

/// The investigation engine.
///
/// The hard rule is "one case at a time": content unlocks by *case*, and a case
/// only opens when the player makes the right connection themselves. Pinning is
/// free; connecting wrong pieces costs battery — so you can't brute-force it.
class GameState extends ChangeNotifier {
  GameState({this.tickEnabled = true});
  final bool tickEnabled;

  GamePhase phase = GamePhase.briefing;

  final Set<String> _pinned = <String>{}; // evidence on the corkboard
  final Set<String> _deductions = <String>{}; // connections made
  final Set<String> _readThreads = <String>{};

  int caseIndex = 1; // active case (1..4)
  bool folderUnlocked = false; // hidden photo folder PIN solved
  String? lastDeductionId; // for a "connection made" flash
  int _hintsUsed = 0; // hints spent on the current case
  int totalHintsUsed = 0; // cumulative, for the end stats
  DateTime? _startedAt;
  DateTime? _endedAt;

  /// How long the investigation took (frozen once it ends).
  Duration get elapsed {
    if (_startedAt == null) return Duration.zero;
    return (_endedAt ?? DateTime.now()).difference(_startedAt!);
  }

  /// Escalating nudges per case. Vague first, more specific later — each costs
  /// battery, so a hint is never free.
  static const _caseHints = <int, List<String>>{
    1: [
      'A Aline quer prova de traição. Isso está fácil demais — tá quase na '
          'superfície. Duas conversas bastam.',
      'No Dossiê, fixe a conversa da "Marina (trampo)" e as desculpas de fim de '
          'semana da Aline, e conecte as duas.',
    ],
    2: [
      'Aquela pasta travada nas Fotos não é à toa. O PIN é um ano que a família '
          'repete o tempo todo — procure no grupo do WhatsApp e nas Notas.',
      'Ligue a selfie de óculos com o que a avó falou no grupo. Depois fixe as '
          'três contas logadas no Tinder e conecte as três.',
    ],
    3: [
      'Os nomes da nota "clientes" são reais. Cruze com as notícias salvas no '
          'Chrome.',
      'As viagens caem nas mesmas datas: Agenda + Nubank + Chrome, mesma cidade. '
          'Isso libera um áudio apagado no Gravador.',
      'Recupere o áudio do Gravador e ligue com a conversa da "B." que some no '
          'meio — é a voz dele buscando ela.',
    ],
    4: [
      'Tem alguém viva agora. Veja o match novo no Tinder e o café marcado na '
          'Agenda pra depois de amanhã, e conecte os dois.',
    ],
  };

  double battery = 87;
  Timer? _ticker;
  bool _silenceFired = false;

  static const folderPin = '1962';

  // ── Views ─────────────────────────────────────────────────────────────
  Set<String> get pinned => Set.unmodifiable(_pinned);
  bool isPinned(String id) => _pinned.contains(id);
  bool hasDeduction(String id) => _deductions.contains(id);
  int get deductionCount => _deductions.length;
  bool isThreadRead(String id) => _readThreads.contains(id);

  InvestigationCase get currentCase => Cases.byIndex(caseIndex);
  bool caseOpen(int i) => caseIndex >= i;

  bool get audioRecoverable =>
      _deductions.contains(Deductions.viagens.id);
  bool get thirdProfileVisible =>
      _deductions.contains(Deductions.disfarce.id);
  bool get accusationReady =>
      _deductions.contains(Deductions.proxima.id);
  bool get alineWentSilent => _silenceFired;

  int get hintsRemaining =>
      (_caseHints[caseIndex]?.length ?? 0) - _hintsUsed;

  /// Threads that start with unread messages — drives the WhatsApp home-icon
  /// badge, which shrinks as the player opens them. (Names must match the chat
  /// data in messages_app.dart.)
  static const _unreadThreads = [
    'Aline ❤️',
    'Almoço de Domingo 🍱',
    '+55 11 9____-____',
    'Pelada de Quinta ⚽',
    'Personal Rodrigo 💪',
    'Condomínio Aurora 🏢',
    'Lucas',
    'Família Andrade 🇯🇵',
  ];
  int get unreadWhatsapp =>
      _unreadThreads.where((t) => !_readThreads.contains(t)).length;

  /// Can this fragment be pinned yet? Gated by which case is open.
  bool evidenceAvailable(String id) =>
      caseIndex >= Ev.byId(id).minCase;

  // ── Lifecycle ─────────────────────────────────────────────────────────
  void startGame() {
    if (phase != GamePhase.briefing) return;
    phase = GamePhase.playing;
    _startedAt = DateTime.now();
    _startTicker();
    notifyListeners();
  }

  void markThreadRead(String id) {
    if (_readThreads.add(id)) notifyListeners();
  }

  bool tryUnlockFolder(String pin) {
    if (folderUnlocked) return true;
    if (pin == folderPin) {
      folderUnlocked = true;
      notifyListeners();
      return true;
    }
    _drain(2);
    return false;
  }

  // ── Pinning ───────────────────────────────────────────────────────────
  void togglePin(String id) {
    if (phase != GamePhase.playing) return;
    if (_pinned.contains(id)) {
      _pinned.remove(id);
    } else {
      _pinned.add(id);
    }
    notifyListeners();
  }

  // ── Connecting (the core puzzle) ──────────────────────────────────────
  ConnectResult connect(Set<String> selected) {
    if (phase != GamePhase.playing) return ConnectResult.none;
    if (selected.length < 2) return ConnectResult.needPin;

    final d = Deductions.match(selected);
    if (d == null) {
      _drain(3); // a wrong theory costs you time
      return ConnectResult.none;
    }
    if (_deductions.contains(d.id)) return ConnectResult.already;
    // The connection must belong to a case that's already open.
    if (d.caseIndex > caseIndex) {
      _drain(3);
      return ConnectResult.none;
    }

    _deductions.add(d.id);
    lastDeductionId = d.id;
    if (d.advances && caseIndex < Cases.count) {
      caseIndex++;
      _hintsUsed = 0; // fresh hints for the new case
      if (caseIndex == 4) _fireSilence(); // "tudo está perdido" beat
    }
    notifyListeners();
    return ConnectResult.linked;
  }

  /// Reveals the next nudge for the current case, costing battery. Returns null
  /// when there are no more hints for this case.
  String? requestHint() {
    if (phase != GamePhase.playing) return null;
    final hints = _caseHints[caseIndex] ?? const [];
    if (_hintsUsed >= hints.length) return null;
    final h = hints[_hintsUsed++];
    totalHintsUsed++;
    _drain(5); // a dying battery doesn't give answers for free
    return h;
  }

  // ── Final accusation ──────────────────────────────────────────────────
  void submitAccusation({required String victimId, required String placeId}) {
    if (phase != GamePhase.playing || !accusationReady) return;
    final correct = victimId == 'leticia' && placeId == 'pinheiros';
    if (correct) {
      phase = GamePhase.solved;
      _endedAt = DateTime.now();
      _stopTicker();
    } else {
      _drain(18);
    }
    notifyListeners();
  }

  void restart() {
    _pinned.clear();
    _deductions.clear();
    _readThreads.clear();
    caseIndex = 1;
    folderUnlocked = false;
    lastDeductionId = null;
    _hintsUsed = 0;
    totalHintsUsed = 0;
    _startedAt = null;
    _endedAt = null;
    battery = 87;
    _silenceFired = false;
    phase = GamePhase.briefing;
    _stopTicker();
    notifyListeners();
  }

  // ── Battery / clock ───────────────────────────────────────────────────
  void _startTicker() {
    if (!tickEnabled) return;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _drain(0.12));
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void debugDrain(double amount) => _drain(amount);

  void _fireSilence() {
    if (!_silenceFired) {
      _silenceFired = true;
      notifyListeners();
    }
  }

  void _drain(double amount) {
    if (phase != GamePhase.playing) return;
    battery = (battery - amount).clamp(0, 100);
    if (!_silenceFired && battery <= 30) _silenceFired = true;
    if (battery <= 0) {
      phase = GamePhase.failed;
      _endedAt = DateTime.now();
      _stopTicker();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
