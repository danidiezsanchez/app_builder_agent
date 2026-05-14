---
id: T-0011
title: Spider — 2-suit + 4-suit difficulty toggle
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0010]
---

## Goal

Expose `suitsCount` in the New Game dialog and propagate red colour through the renderer.

## Scope

- In: `apps/spider_solitaire/lib/ui/home_page.dart`, and possibly `card_widget.dart` if red colour isn't yet wired (it should already be from `T-0007`).
- Out: scoring differences between difficulties.

## Deliverables

1. New Game confirm dialog includes a `RadioListTile` group: `1-suit (easy)`, `2-suit (medium)`, `4-suit (hard)`.
2. Selected value passed to `gameState.newGame(suitsCount: ...)`.
3. Default remains `1`.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] `flutter test` still green
- [ ] Starting a 4-suit game shows all four suit glyphs in the tableau (verify in screenshot)

## Context links

- Engine accepts suitsCount: `projects/project2/ARCHITECTURE.md`

## Notes for admin

Branch: `cursor/spider-t0011-difficulty-ac06`. Target branch: `project2`.
