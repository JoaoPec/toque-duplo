# Toque Duplo

Thriller investigativo em Flutter. Você é um detetive móvel: a cliente, Aline,
entrega o celular do namorado pra você "confirmar uma traição". O celular prova
a traição em dez minutos — e passa as duas horas seguintes provando que ele é
três homens diferentes, e que duas das mulheres com quem ele saiu nunca mais
foram vistas.

Baseado na bíblia narrativa `documentacao_historia.zip` (raiz do repo).

## Como rodar

App **mobile-only** (Android/iOS), retrato.

```bash
cd app
flutter pub get
flutter run            # com um celular/emulador conectado
flutter test           # lógica do jogo
```

## A mecânica — deduzir, não tropeçar

O jogo **não** entrega as conclusões. Você investiga de verdade:

1. **Coletar provas.** Os apps são cheios de conteúdo — e de ruído. Quando uma
   frase, foto ou lançamento te cheira mal, você **fixa** (segura o item ou toca
   no 📌). O jogo nunca diz quais provas importam; várias são becos sem saída.
2. **Conectar.** No **Dossiê**, você seleciona 2–3 provas fixadas e tenta
   **conectar**. Só o par/trio certo forma uma **dedução**. Ligação errada = você
   perdeu tempo (e bateria).
3. **Um caso por vez.** A investigação tem 4 casos. O próximo só abre quando você
   fecha o atual com a dedução-chave. Conteúdo (a pasta oculta, a 3ª persona, o
   match da Letícia, o áudio da lixeira) só aparece no caso certo.
4. **A bateria é o cronômetro.** Drena em tempo real; deduções erradas aceleram.
   0% = final ruim.
5. **A acusação.** Fechado o caso 4, o Dossiê libera nomear a próxima vítima e o
   local. Acertar = final bom; errar = bateria queimada.

### Os 4 casos (gating sequencial)

| Caso | Pergunta | Dedução que fecha |
|------|----------|-------------------|
| 1 — A traição | Ele trai? | flerte da Marina **+** desculpa da Aline |
| 2 — O homem de três caras | Por que disfarce? | selfie de óculos **+** "a vó: você nunca usou grau" → revela as 3 personas; conectar os **3 perfis** fecha |
| 3 — As mulheres | Onde elas estão? | conversa da "B." cortada **+** áudio recuperado (a voz "Theo") |
| 4 — A próxima | Café com quem? | match da Letícia **+** "café — L., Pinheiros" |

Puzzle extra: a pasta **Documentos/Trabalho** no app de Fotos é trancada por um
**PIN de 4 dígitos** — a dica ("o ano que ele usa pra tudo") está plantada no
WhatsApp da família e nas Notas (`1962`).

### Dois finais

- **Bom:** acusa Letícia + Pinheiros a tempo. Rafael é pego antes do quarto crime.
- **Ruim:** a bateria estoura — você ficou preso na traição banal (a Marina).

### Ajudas e feedback

- **Dicas** (no Dossiê): nudges escalonados por caso, cada um custa 5% de bateria
  — pra não travar sem entregar a solução.
- **"Caso fechado"**: overlay comemorativo quando uma conexão fecha um caso.
- **Vibração** (haptics) ao fixar prova e ao conectar.
- **Badge** vermelho no ícone do WhatsApp (não-lidas) e do Dossiê (provas).
- **Conversas no Tinder**: tocar num match abre o chat — a escalada arrepiante
  da Letícia, e o padrão "vamos pro zap" das vítimas.

## Home no estilo iOS

A tela inicial imita o iOS: papel de parede em gradiente, ícones squircle
coloridos num grid 4×4 (sem dock), page dots embaixo. O **Dossiê** é um app com
**badge vermelho** (igual notificação) mostrando quantas provas estão fixadas.

## Apps

**Investigação (interfaces no estilo dos reais):** **WhatsApp** (verde, bolhas +
ticks azuis, arquivadas, grupos, não-lidas), **Tinder** (cards, troca de contas
logadas), **Fotos** (grid + pasta com PIN), **Chrome** (histórico + páginas),
**Notas** (iOS), **Agenda**, **Nubank** (roxo, extrato), **99** (corridas com
rota), **Gravador** (lixeira + áudio recuperado), **Dossiê**.

**De enfeite (funcionam, mas não têm pista — só pra parecer um celular real e
esconder o que importa):** **Calculadora** (funcional, visual do iOS), **Relógio**,
**Tempo** (clima), **Ajustes**, **Câmera** e **Música** (abrem com "nada por
aqui").

Conteúdo (muito ruído de propósito — pra você se perder e ter que garimpar):
~36 fragmentos de prova entre **~24 conversas de WhatsApp**, **~23 lançamentos no
extrato**, **~14 corridas no 99**, **~10 matches mortos no Tinder**, além de
buscas, notas, eventos de agenda e áudios inúteis.

As conversas principais têm **profundidade real** — a da **Aline** (namorada) é o
arco de 7 meses do relacionamento (love-bombing → controle → ausências →
desconfiança), com **divisores de data**, **bolhas de áudio** (notas de voz) e
**fotos**. Cada vítima (Camila, Bia, Iasmin) tem sua conversa arquivada que se
constrói devagar até **cortar no meio** do desaparecimento. As pistas reais estão
enterradas no meio de tudo isso.

## Testar no navegador

```bash
flutter build web --no-tree-shake-icons --no-web-resources-cdn
npx serve -s build/web -l 8100   # http://localhost:8100
```

O `--no-web-resources-cdn` empacota o CanvasKit localmente (sem isso, ambientes
offline ficam com tela preta).

## Arquitetura

```
lib/
  main.dart                 # bootstrap + ChangeNotifierProvider<GameState> + retrato
  theme.dart                # identidade visual
  game/
    evidence.dart           # toda prova fixável (incl. red herrings)
    deduction.dart          # os 4 casos + as receitas de conexão
    game_state.dart         # motor: pin, connect, gating por caso, bateria, finais
  ui/
    root.dart               # troca de fase
    briefing_screen.dart    # "O briefing"
    phone_shell.dart        # status bar (bateria), lock screen, grid de apps
    dossier_screen.dart     # quadro de provas + conectar + acusação
    ending_screen.dart      # os dois desfechos
    widgets.dart            # AppShell, PinButton, Pinnable
    apps/                   # os 9 apps (um arquivo cada)
```

### Como a história vira código

- Cada fragmento do **MAPA DE PISTAS POR APP** da bíblia é uma `Evidence` em
  [`evidence.dart`](lib/game/evidence.dart); as conclusões são `Deduction`s em
  [`deduction.dart`](lib/game/deduction.dart), agrupadas por caso (beats Save the
  Cat).
- O **gating "um caso por vez"** está em `GameState`: `caseIndex`,
  `evidenceAvailable`, `connect()`, `thirdProfileVisible`, `audioRecoverable`,
  `accusationReady`.
- O **foreshadowing** (óculos → fantasia, "Okinawa", a loja de 62 → o PIN) está
  plantado nos textos e só "fecha" quando você faz a conexão certa.

## Onde a história foi complementada

- **Mais conversas e ruído**: além de Aline/Marina/família/"B.", entram contatos
  inócuos (Jorge corretor, Mãe) e provas-isca (comissão de venda, álbum de praia,
  áudio pra vó) pra que descobrir não seja automático.
- **Puzzle do PIN** da pasta oculta, com a dica plantada em dois apps.
- **Acusação** com dois campos deduzidos — a tradução jogável de "monta o dossiê
  e envia".
- **Bateria diegética** + **silêncio da Aline** (dispara no caso 4 ou com bateria
  baixa — o beat "tudo está perdido").
