---
id: T-0005
title: Spider — engine rules and GameState
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: med
iteration: allowed
depends_on: [T-0004]
---

## Goal

Implement spider solitaire game logic and the `GameState` ChangeNotifier driving it.

## Scope

- In:
  - `apps/spider_solitaire/lib/engine/rules.dart` — pure functions:
    - `int detectRunLength(Pile pile)` — number of cards from the top that form a descending same-suit face-up run.
    - `bool canDrop(List<PlayingCard> run, Pile dest)` — true if run can drop on `dest` (empty pile always OK; otherwise `dest.top.value == run.first.value + 1`; run must already be a valid same-suit descending sequence).
    - `int? completedSuitStart(Pile pile)` — returns index of K if the **top 13 cards** form K→A same-suit run, else `null`.
  - `apps/spider_solitaire/lib/engine/game_state.dart` — `class GameState extends ChangeNotifier` with the API in `ARCHITECTURE.md`:
    - `newGame({int? seed, int suitsCount = 1})` — deals 6/6/6/6/5/5/5/5/5/5 from a fresh shuffled deck, top card face-up per column, remainder in `stock`.
    - `selection`, `selectAt(col, idx)`, `dropOn(destCol)`, `dealFromStock()`, `isWon`.
- Out: any UI; any persistence.

## Deliverables

1. Two files above.
2. `lib/engine/rules.dart` is pure (no Flutter import); `game_state.dart` imports only `package:flutter/foundation.dart` for `ChangeNotifier`.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] After `newGame(seed: 1)`: column lengths are exactly `[6,6,6,6,5,5,5,5,5,5]`, top card of each column has `faceUp == true`, `stock.length == 50`
- [ ] `dealFromStock()` returns `false` and does not mutate state if **any** column is empty
- [ ] `dealFromStock()` deals exactly one face-up card to each column when allowed, decrements `stock` by 10
- [ ] After a move that empties the face-up part of a column, the next face-down card flips face-up
- [ ] When the top 13 cards of a column form a K→A same-suit run, they are removed and `completedSuits` increments

## Context links

- Spec: `projects/project2/SPEC.md`
- Architecture: `projects/project2/ARCHITECTURE.md`

## Notes for admin

Branch: `cursor/spider-t0005-rules-ac06`. Target branch: `project2`. **Stop and escalate** if completed-suit collection produces inconsistent state across two test runs.
