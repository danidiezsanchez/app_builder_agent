---
id: T-0004
title: Spider — engine models (PlayingCard, Deck, Pile)
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0003]
---

## Goal

Add the **pure-Dart** model classes that describe the spider deck and tableau. No Flutter imports.

## Scope

- In:
  - `apps/spider_solitaire/lib/engine/card.dart` — `Suit`, `Rank`, `PlayingCard { suit, rank, faceUp }`, `int get value` (Ace = 1 … King = 13), `String get glyph` (rank char `A 2…10 J Q K`).
  - `apps/spider_solitaire/lib/engine/deck.dart` — `Deck.shuffled({required int suitsCount, int? seed}) -> List<PlayingCard>` returning 104 face-down cards. Valid `suitsCount`: 1, 2, 4.
  - `apps/spider_solitaire/lib/engine/pile.dart` — `Pile { final List<PlayingCard> cards; PlayingCard? get top; List<PlayingCard> takeFromIndex(int i); }`.
- Out: rules, game state, any UI.

## Deliverables

1. Three files above with the exact public API.
2. No new packages.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] No `import 'package:flutter/...';` anywhere under `lib/engine/`
- [ ] `Deck.shuffled(suitsCount: 1, seed: 42)` is **deterministic** (same call → identical list)
- [ ] `Deck.shuffled(suitsCount: 1)` length == 104 and every suit == `Suit.spades`
- [ ] `Deck.shuffled(suitsCount: 4)` contains exactly 26 cards of each suit

## Context links

- Architecture: `projects/project2/ARCHITECTURE.md` (Engine contracts section)

## Notes for admin

Branch: `cursor/spider-t0004-models-ac06`. Target branch: `project2`.
