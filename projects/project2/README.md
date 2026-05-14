# Project 2 — Spider Solitaire (text-card MVP)

Planning hub for **`project2`**. Code lives on git branch **`project2`** (future), not on `main`.

## One-liner

Cross-platform mobile **Spider Solitaire** built in **Flutter**. Cards rendered as **Unicode glyphs** (no image assets) for the MVP — keeps the artwork budget at zero while staying fully playable on iOS + Android later.

## Status

| Item | State |
|------|-------|
| Spec | ready — see [`SPEC.md`](SPEC.md) |
| Stack pick | ready — Flutter, see [`STACK.md`](STACK.md) |
| Architecture | ready — see [`ARCHITECTURE.md`](ARCHITECTURE.md) |
| Card rendering plan | ready — see [`CARD_RENDERING.md`](CARD_RENDERING.md) |
| Task plan | ready — see [`TASK_PLAN.md`](TASK_PLAN.md) |
| Code | not started — needs branch `project2` |

## Branching

- This doc set lands on `main` (instruction-allowlist auto-merge friendly).
- Implementation PRs target **`project2`** (long-lived). See [`docs/MERGE_AND_BRANCHING.md`](../../docs/MERGE_AND_BRANCHING.md).

## For executing agents

Read in order:

1. [`SPEC.md`](SPEC.md) — what the game must do
2. [`STACK.md`](STACK.md) — Flutter, Dart, lints
3. [`CARD_RENDERING.md`](CARD_RENDERING.md) — Unicode card glyphs
4. [`ARCHITECTURE.md`](ARCHITECTURE.md) — modules + state
5. [`TASK_PLAN.md`](TASK_PLAN.md) — milestones + task IDs
6. [`AGENT_GUIDE.md`](AGENT_GUIDE.md) — how to pick up a single task with a cheap model

Each milestone is split into junior-dev tasks under `tasks/active/T-0003…T-0012`. **Pick exactly one task per session.**
