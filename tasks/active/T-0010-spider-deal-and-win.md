---
id: T-0010
title: Spider — Deal-from-stock + New game + Win snackbar
title_short: Deal & win UX
status: ready
role: junior-dev
recommended_model: composer-2-fast
estimated_tokens: low
iteration: allowed
depends_on: [T-0009]
---

## Goal

Add the three remaining MVP UI affordances: Deal, New Game, and a "You win!" snackbar.

## Scope

- In: `apps/spider_solitaire/lib/ui/home_page.dart` (extend existing).
- Out: animations, statistics, settings.

## Deliverables

1. AppBar trailing actions: `IconButton(Icons.style)` calling `gameState.dealFromStock()`, disabled when `gameState.stock.isEmpty`. If the call returns `false` because a column is empty, show a `SnackBar("Cannot deal — column empty")`.
2. AppBar trailing action: `IconButton(Icons.refresh)` calling `gameState.newGame(suitsCount: 1)` after a confirm dialog.
3. After every `notifyListeners`, check `gameState.isWon`. On first transition to won, show a `SnackBar("You win! 🎉")` (one-off, don't re-fire on rebuild).

## Acceptance criteria

- [ ] `flutter analyze` clean
- [ ] `flutter test` still green
- [ ] Manual run: 5 successive Deal taps empty the stock, button then disables
- [ ] Manual run: New Game confirm dialog, accepting resets the board

## Context links

- Spec: `projects/project2/SPEC.md`

## Notes for admin

Branch: `cursor/spider-t0010-deal-and-win-ac06`. Target branch: `project2`.
