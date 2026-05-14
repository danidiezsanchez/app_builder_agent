# AGENT_GUIDE — picking up a spider task on a cheap model

Target: **Haiku / Composer-2-fast** class agent. Stay surgical, do not load the whole repo.

## Before you start

1. Read **only** these files:
   - `roles/junior-dev/INSTRUCTIONS.md`
   - `.cursor/rules/karpathy-guidelines.mdc`
   - `projects/project2/SPEC.md`
   - `projects/project2/ARCHITECTURE.md` (only the section your task names)
   - `projects/project2/CARD_RENDERING.md` (only if the task is UI)
   - Your **own** `tasks/active/T-nnnn-*.md`
2. Skip every other project (`project1`, etc.).
3. Confirm Flutter SDK: `flutter --version`. If missing, abort and report.

## Branch rules

- All implementation PRs target **`project2`**, not `main`.
- Branch name: `cursor/spider-<task-id>-<slug>-ac06`. Example: `cursor/spider-t0004-models-ac06`.
- If `project2` branch does not yet exist on remote, the first task (`T-0003`) creates it from `main`.

## Editing rules

- Touch **only** the paths your task's `Scope.In` lists.
- Do **not** edit `projects/project2/*.md` while implementing — those are the spec.
- Do **not** refactor code outside your task.
- No new dependencies unless the task explicitly says so.

## Verification loop (every task)

```bash
cd apps/spider_solitaire
flutter analyze
flutter test
```

Both must be clean before commit. UI-touching tasks must additionally launch the app once (`flutter run -d linux`) and confirm the screen renders without exceptions — paste the run output into the PR body.

## Output shape per PR

- Title: `T-nnnn: <task title>`
- Body:
  - What changed (3 bullets max)
  - `flutter analyze` output (paste)
  - `flutter test` output (paste)
  - Screenshot or text dump (UI tasks)
- Move task file from `tasks/active/` to `tasks/done/` in the same PR.

## Escalate to senior-dev when

- The rule check `Rules.detectRun` produces results inconsistent with `SPEC.md`.
- Auto-collection of completed suit corrupts column state.
- More than 2 retry loops on the same failing test.

In those cases: **do not patch over** — open a `T-9xxx-spider-blocker-*.md` task with the failing reproduction and stop.
