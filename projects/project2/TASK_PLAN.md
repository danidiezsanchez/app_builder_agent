# TASK_PLAN — milestones and tasks

Each task is **scoped for a junior-dev agent on a cheap model** (Haiku / Composer-2-fast class). Pick **one task per session**.

All implementation tasks land PRs on branch **`project2`** (create from `main` once `T-0003` runs).

## Milestones

| # | Name | Tasks |
|---|------|-------|
| M1 | Skeleton | `T-0003` |
| M2 | Engine | `T-0004`, `T-0005`, `T-0006` |
| M3 | UI | `T-0007`, `T-0008`, `T-0009` |
| M4 | Polish to MVP | `T-0010`, `T-0011`, `T-0012` |

## Dependency chain

```
T-0003 → T-0004 → T-0005 → T-0006 ┐
                                  ├→ T-0009 → T-0010 → T-0011 → T-0012
                  T-0007 → T-0008 ┘
```

## Task index (full files under `tasks/active/`)

| ID | Title | Role | Tokens |
|----|-------|------|--------|
| [T-0003](../../tasks/active/T-0003-spider-flutter-scaffold.md) | Flutter scaffold for spider solitaire | junior-dev | low |
| [T-0004](../../tasks/active/T-0004-spider-engine-models.md) | Engine models: `PlayingCard`, `Deck`, `Pile` | junior-dev | low |
| [T-0005](../../tasks/active/T-0005-spider-engine-rules.md) | Engine rules: move legality, run detection, suit collection | junior-dev | med |
| [T-0006](../../tasks/active/T-0006-spider-engine-tests.md) | Engine unit tests | junior-dev | low |
| [T-0007](../../tasks/active/T-0007-spider-ui-card-widget.md) | `CardWidget` text rendering | junior-dev | low |
| [T-0008](../../tasks/active/T-0008-spider-ui-column-widget.md) | `ColumnWidget` with overlap stack | junior-dev | low |
| [T-0009](../../tasks/active/T-0009-spider-ui-home-page.md) | `HomePage` wiring + tap-to-move | junior-dev | med |
| [T-0010](../../tasks/active/T-0010-spider-deal-and-win.md) | Deal-from-stock button + win snackbar | junior-dev | low |
| [T-0011](../../tasks/active/T-0011-spider-2-and-4-suit-mode.md) | Add 2-suit + 4-suit difficulty toggle | junior-dev | low |
| [T-0012](../../tasks/active/T-0012-spider-mobile-build-smoke.md) | Mobile build smoke: `flutter build apk --debug` | junior-dev | low |

## Budget guardrails

- Each task must close with `flutter analyze` clean and `flutter test` green.
- If a task balloons (>2 retry loops), agent **stops and reports**; coordinator splits the task — do not bundle more scope.
- All engine work stays Flutter-import-free. If a task touches both engine and UI, it's the wrong size — split it.
