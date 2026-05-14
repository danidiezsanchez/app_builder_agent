---
id: T-0009
title: Spider — HomePage wiring + tap-to-move
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: med
iteration: allowed
depends_on: [T-0005, T-0008]
---

## Goal

Hook up `GameState` to the UI: render 10 columns in a `Row`, tap a card to select, tap a destination column to drop.

## Scope

- In:
  - `apps/spider_solitaire/lib/ui/home_page.dart` — `HomePage` stateful widget owning a single `GameState` instance.
  - Update `apps/spider_solitaire/lib/main.dart` to use `HomePage` as the home.
- Out: deal-button, win snackbar (those are `T-0010`), difficulty toggle (`T-0011`).

## Deliverables

1. `HomePage` builds `AnimatedBuilder` on the `GameState` instance.
2. AppBar shows `Completed: ${gameState.completedSuits} / 8`.
3. Body: horizontal `Row` of 10 `ColumnWidget`, scrollable horizontally on narrow screens (`SingleChildScrollView(scrollDirection: Axis.horizontal)`).
4. Tap handling:
   - On card tap: call `gameState.selectAt(col, idx)`. If it returns `false`, do nothing.
   - On column tap: if `gameState.selection != null`, call `gameState.dropOn(col)`. If it returns `false`, clear selection.
5. New game on app launch: `gameState.newGame(suitsCount: 1)` in `initState`.

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] `flutter run -d linux` opens a window showing 10 columns with face-down cards plus a face-up top per column
- [ ] Tapping a valid card highlights it; tapping a legal destination moves the run; illegal destination clears selection
- [ ] Paste run output into PR body, attach 1 screenshot

## Context links

- Architecture: `projects/project2/ARCHITECTURE.md`
- Spec UX section: `projects/project2/SPEC.md`

## Notes for admin

Branch: `cursor/spider-t0009-home-page-ac06`. Target branch: `project2`.
