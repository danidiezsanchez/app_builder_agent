---
id: T-0007
title: Spider — CardWidget text rendering
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0004]
---

## Goal

Single stateless widget that renders one `PlayingCard` (or face-down placeholder) using Unicode glyphs only.

## Scope

- In: `apps/spider_solitaire/lib/ui/card_widget.dart` — `CardWidget({required PlayingCard card, bool selected = false})` and `CardWidget.faceDown()`.
- Out: tap handling (lives in `ColumnWidget` / `HomePage`), animations, theming, image assets.

## Deliverables

1. Box: width 36, height 52, rounded `BorderRadius.circular(4)`, white background, black border (`Border.all(width: selected ? 2 : 1, color: selected ? Colors.blue : Colors.black54)`).
2. Face-up content: a `Column` with rank glyph on top, suit glyph below, monospace font size 14. Colour: red shade 700 for ♥/♦, black for ♠/♣.
3. Face-down content: a single centred `▒` glyph filling the box (same dimensions).
4. **No** other dependencies, **no** business logic.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] Widget imports nothing from `engine/` except `card.dart`
- [ ] Manual smoke: a throwaway page placing `CardWidget(card: PlayingCard(Suit.spades, Rank.king, faceUp: true))` next to `CardWidget.faceDown()` renders both boxes (paste a screenshot in PR body)

## Context links

- Rendering plan: `projects/project2/CARD_RENDERING.md`

## Notes for admin

Branch: `cursor/spider-t0007-card-widget-ac06`. Target branch: `project2`.
