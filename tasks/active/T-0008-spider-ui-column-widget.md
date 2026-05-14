---
id: T-0008
title: Spider — ColumnWidget with overlap stack
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0007]
---

## Goal

Render one tableau column: vertical overlapping stack of `CardWidget`s, with tap callbacks per card and a "drop here" tap on the column itself.

## Scope

- In: `apps/spider_solitaire/lib/ui/column_widget.dart` — `ColumnWidget({required Pile pile, required int columnIndex, int? selectedIndex, required void Function(int colIdx, int cardIdx) onCardTap, required void Function(int colIdx) onColumnTap})`.
- Out: any direct mutation of `GameState`; selection logic.

## Deliverables

1. `Stack` of `CardWidget`s, each offset `top: index * 22.0` from the column origin.
2. Empty pile: render the dashed empty-column placeholder from `CARD_RENDERING.md` (a `DottedBorder` is **not** required — use `DashedDecoration`-free fallback: solid `Border.all(color: Colors.black26)` with a centred `·`).
3. Each `CardWidget` wrapped in `GestureDetector` calling `onCardTap(columnIndex, cardIdx)`. The whole column wrapped in a wider `GestureDetector` calling `onColumnTap(columnIndex)` for the "drop on empty area" case.
4. Selection visual: passes `selected: true` to every card from `selectedIndex` upward.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] Widget compiles, no missing-key warnings
- [ ] Top card always reachable by tap (no overlapping `GestureDetector` swallowing it)
- [ ] Empty column renders a placeholder of the same dimensions as a card

## Context links

- Rendering plan: `projects/project2/CARD_RENDERING.md`

## Notes for admin

Branch: `cursor/spider-t0008-column-widget-ac06`. Target branch: `project2`.
