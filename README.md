<h1 align="center">Toque Duplo</h1>

<p align="center"><em>Investigative thriller — you never appear on screen. You just go through his phone.</em></p>

<p align="center">
  <img src="app/assets/images/reference/rafael_personas_sheet.png" width="80%" alt="Rafael's three dating personas" />
</p>

<!-- DEMO: grave um GIF de gameplay (3-5s navegando no celular/montando provas), salve em docs/demo.gif e descomente
<p align="center">
  <img src="docs/demo.gif" width="40%" alt="Gameplay — investigating the phone" />
</p>
-->

> A woman hires you to confirm a run-of-the-mill cheating suspicion. Her boyfriend's phone proves the affair in ten minutes — then spends the next two hours proving he is **three different men**, and that two of the women he dated were never seen again.

## What it is

A mobile narrative detective game built in **Flutter**. You play a phone-forensics investigator: a client hands you her boyfriend's seized phone and you explore it like a real device — chats, gallery, dating apps, saved stories — piecing together evidence against a timer. The deeper you dig, the further it slides from petty infidelity toward something much darker.

Set in São Paulo, 2025. Realistic, urban tone. The hook: the more "good family" and "trustworthy" someone looks, the less anyone checks.

## Gameplay

- **🔍 Explore a real phone** — navigate apps inside a phone shell UI (chats, gallery, dating profiles, dossier).
- **🧩 Evidence & deduction** — collect clues and connect them to expose the persona behind each victim.
- **⏱️ Race the clock** — one victim is still missing. Solve it in time and you can still save the next.
- **🎭 The tell** — three Tinder personas on one device. One small detail he forgot to delete cracks the whole case.

## Tech

`Flutter` · `Dart` · mobile-only (Android / iOS), portrait. Game logic (`evidence`, `deduction`, `game_state`) covered by unit tests.

## Run it

```bash
cd app
flutter pub get
flutter run     # with a device/emulator connected
flutter test    # game logic
```

---

<sub>Fiction. All characters and events are invented. Full story bible lives in `.story_docs/`.</sub>
