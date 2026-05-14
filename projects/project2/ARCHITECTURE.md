# ARCHITECTURE — modules and state

Single-screen Flutter app. Clear split between **pure-Dart engine** (testable headless) and **Flutter UI** (no game logic).

```
┌──────────────────────────────────────────────┐
│  ui/HomePage  (StatefulWidget)               │
│   ├─ AppBar: completed counter, Deal, New    │
│   └─ Row of 10 ColumnWidget                  │
│        └─ Stack of CardWidget                │
│                                              │
│  state: GameState (ChangeNotifier)           │
│   ├─ List<Pile> columns                      │
│   ├─ List<PlayingCard> stock                 │
│   ├─ int completedSuits                      │
│   └─ Selection? selection                    │
│                                              │
│  engine (pure Dart, no Flutter import)       │
│   ├─ PlayingCard { Rank, Suit, faceUp }      │
│   ├─ Deck.shuffled(seed, suits)              │
│   ├─ Rules.canDrop(run, dest)                │
│   ├─ Rules.detectRun(pile)                   │
│   └─ Rules.collectCompletedSuit(pile)        │
└──────────────────────────────────────────────┘
```

## Engine contracts (must be honoured by `T-0005`)

```dart
enum Suit { spades, hearts, diamonds, clubs }
enum Rank { ace, two, three, four, five, six, seven,
            eight, nine, ten, jack, queen, king }

class PlayingCard {
  final Suit suit;
  final Rank rank;
  bool faceUp;
}

class Pile {           // one tableau column
  final List<PlayingCard> cards;       // bottom → top
  // top = cards.last
}

class GameState extends ChangeNotifier {
  List<Pile> columns;                  // length 10
  List<PlayingCard> stock;             // remaining undealt
  int completedSuits;                  // 0..8
  Selection? selection;

  void newGame({int? seed, int suitsCount = 1});
  bool selectAt(int columnIndex, int cardIndex);   // returns true if valid run start
  bool dropOn(int destColumnIndex);                // executes move if legal
  bool dealFromStock();                            // false if any column empty
  bool get isWon => completedSuits == 8;
}
```

## State updates

- All mutations on `GameState` go through methods that:
  1. Validate (pure functions in `rules.dart`).
  2. Apply mutation.
  3. Flip newly-exposed face-down top cards.
  4. Auto-collect any completed K→A same-suit run.
  5. `notifyListeners()`.

## UI subscription

`HomePage` wraps body in `AnimatedBuilder(animation: gameState, builder: …)`. No other widget holds game state.

## Determinism for tests

`Deck.shuffled(seed)` uses Dart `Random(seed)` so engine tests are deterministic.

## What deliberately does **not** exist yet

- No `Provider` / `Riverpod` / `Bloc`.
- No router (single screen).
- No persistence layer.
- No theming abstraction.

Adding any of these requires a new task with explicit justification.
