import 'package:flutter_test/flutter_test.dart';
import 'package:toque_duplo/game/deduction.dart';
import 'package:toque_duplo/game/game_state.dart';

void main() {
  // tickEnabled: false freezes the battery so we drive the clock by hand.
  GameState newGame() => GameState(tickEnabled: false)..startGame();

  test('starts in briefing, then plays', () {
    final g = GameState(tickEnabled: false);
    expect(g.phase, GamePhase.briefing);
    g.startGame();
    expect(g.phase, GamePhase.playing);
    expect(g.caseIndex, 1);
  });

  test('pinning is a free toggle', () {
    final g = newGame();
    g.togglePin('marina_flirt');
    expect(g.isPinned('marina_flirt'), isTrue);
    final before = g.battery;
    g.togglePin('marina_flirt');
    expect(g.isPinned('marina_flirt'), isFalse);
    expect(g.battery, before); // no cost
  });

  test('a correct connection makes the deduction and can advance the case', () {
    final g = newGame();
    g.togglePin('marina_flirt');
    g.togglePin('aline_excuse');
    expect(g.connect({'marina_flirt', 'aline_excuse'}), ConnectResult.linked);
    expect(g.hasDeduction(Deductions.traicao.id), isTrue);
    expect(g.caseIndex, 2); // case 1 closed → case 2 open
  });

  test('a wrong connection costs battery and yields nothing', () {
    final g = newGame();
    final before = g.battery;
    expect(g.connect({'marina_flirt', 'bank_comissao'}), ConnectResult.none);
    expect(g.deductionCount, 0);
    expect(g.battery, lessThan(before));
  });

  test('cannot connect a future-case deduction early', () {
    final g = newGame(); // still case 1
    // The "personas" recipe belongs to case 2.
    expect(g.connect({'profile_rafa', 'profile_theo', 'profile_gui'}),
        ConnectResult.none);
    expect(g.hasDeduction(Deductions.personas.id), isFalse);
  });

  test('evidence is gated by the open case', () {
    final g = newGame(); // case 1
    expect(g.evidenceAvailable('glasses_selfie'), isFalse); // minCase 2
    expect(g.evidenceAvailable('marina_flirt'), isTrue);
  });

  test('hidden folder opens only with the right PIN', () {
    final g = newGame();
    expect(g.tryUnlockFolder('0000'), isFalse);
    expect(g.folderUnlocked, isFalse);
    expect(g.tryUnlockFolder(GameState.folderPin), isTrue);
    expect(g.folderUnlocked, isTrue);
  });

  test('full chain reaches case 4 and enables the accusation', () {
    final g = newGame();
    // Case 1
    g.connect({'marina_flirt', 'aline_excuse'});
    // Case 2
    g.connect({'glasses_selfie', 'familia_oculos'}); // disfarce (side)
    expect(g.thirdProfileVisible, isTrue);
    g.connect({'profile_rafa', 'profile_theo', 'profile_gui'}); // advances
    expect(g.caseIndex, 3);
    // Case 3
    g.connect({'client_list', 'news_moema'});
    g.connect({'cal_maresias', 'bank_pousada', 'news_maresias'}); // unlocks audio
    expect(g.audioRecoverable, isTrue);
    g.connect({'bia_chat_cut', 'audio_recovered'}); // advances
    expect(g.caseIndex, 4);
    // Case 4
    expect(g.accusationReady, isFalse);
    g.connect({'leticia_match', 'cafe_calendar'});
    expect(g.accusationReady, isTrue);
  });

  test('correct accusation = good ending; wrong only when ready', () {
    final g = newGame();
    // not ready yet → no-op
    g.submitAccusation(victimId: 'leticia', placeId: 'pinheiros');
    expect(g.phase, GamePhase.playing);

    // walk to ready
    g.connect({'marina_flirt', 'aline_excuse'});
    g.connect({'glasses_selfie', 'familia_oculos'});
    g.connect({'profile_rafa', 'profile_theo', 'profile_gui'});
    g.connect({'client_list', 'news_moema'});
    g.connect({'cal_maresias', 'bank_pousada', 'news_maresias'});
    g.connect({'bia_chat_cut', 'audio_recovered'});
    g.connect({'leticia_match', 'cafe_calendar'});

    g.submitAccusation(victimId: 'iasmin', placeId: 'moema'); // wrong
    expect(g.phase, GamePhase.playing);
    g.submitAccusation(victimId: 'leticia', placeId: 'pinheiros'); // right
    expect(g.phase, GamePhase.solved);
  });

  test('extra case-3 deductions (ride + first victim) are optional', () {
    final g = newGame();
    g.connect({'marina_flirt', 'aline_excuse'}); // case 2
    g.connect({'profile_rafa', 'profile_theo', 'profile_gui'}); // case 3
    expect(g.caseIndex, 3);
    // These enrich case 3 but don't advance it.
    expect(g.connect({'ride_rodoviaria', 'bia_chat_cut'}), ConnectResult.linked);
    expect(g.hasDeduction(Deductions.rodoviaria.id), isTrue);
    expect(g.connect({'camila_chat_cut', 'news_pinheiros'}), ConnectResult.linked);
    expect(g.hasDeduction(Deductions.pinheirosVitima.id), isTrue);
    expect(g.connect({'iasmin_chat_cut', 'ride_moema'}), ConnectResult.linked);
    expect(g.hasDeduction(Deductions.moemaVitima.id), isTrue);
    expect(g.caseIndex, 3); // still case 3
  });

  test('hints reveal in order, cost battery, and reset per case', () {
    final g = newGame();
    expect(g.hintsRemaining, 2); // case 1 has 2 hints
    final before = g.battery;
    final h1 = g.requestHint();
    expect(h1, isNotNull);
    expect(g.battery, lessThan(before)); // costs battery
    expect(g.hintsRemaining, 1);
    g.requestHint();
    expect(g.hintsRemaining, 0);
    expect(g.requestHint(), isNull); // no more for this case

    // Advancing the case refills hints.
    g.connect({'marina_flirt', 'aline_excuse'});
    expect(g.caseIndex, 2);
    expect(g.hintsRemaining, 2); // case 2 has 2 hints
  });

  test('whatsapp unread badge shrinks as threads are read', () {
    final g = newGame();
    final start = g.unreadWhatsapp;
    expect(start, greaterThan(0));
    g.markThreadRead('Aline ❤️');
    expect(g.unreadWhatsapp, start - 1);
  });

  test('battery reaching zero triggers the failed ending', () {
    final g = newGame();
    g.debugDrain(200);
    expect(g.phase, GamePhase.failed);
  });
}
