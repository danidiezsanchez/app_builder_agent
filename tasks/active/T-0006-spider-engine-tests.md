---
id: T-0006
title: Spider — engine unit tests
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0005]
---

## Goal

Cover engine behaviour with deterministic unit tests, no widgets.

## Scope

- In:
  - `apps/spider_solitaire/test/card_test.dart`
  - `apps/spider_solitaire/test/rules_test.dart`
  - `apps/spider_solitaire/test/game_state_test.dart`
- Out: widget tests, integration tests, golden tests.

## Deliverables

Tests covering at minimum:

1. `PlayingCard.value` and `.glyph` for ace, ten, jack, king.
2. `Deck.shuffled` determinism with same seed; correct count per suit at suitsCount 1/2/4.
3. `detectRunLength` for: empty pile (0), single face-up card (1), 3-card same-suit descending run (3), mixed-suit broken run (top run only).
4. `canDrop` for: empty pile + any run (true), one-rank-lower top (true), same-rank top (false), wrong-rank top (false).
5. `newGame(seed: 1)` column shape & stock size.
6. `dealFromStock` rejected when a column is empty.
7. Completed K→A run is collected and `completedSuits` increments.

## Acceptance criteria

- [ ] `flutter test` shows all new tests passing
- [ ] At least one assertion per item in Deliverables (7 items → ≥ 7 assertions)
- [ ] No widget imports in any test file

## Context links

- Spec + Architecture in `projects/project2/`.

## Notes for admin

Branch: `cursor/spider-t0006-engine-tests-ac06`. Target branch: `project2`.
