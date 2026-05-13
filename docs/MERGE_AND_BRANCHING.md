# Merge automation and branching

Goal: **stop hand-merging every agent PR** when changes are safe and repetitive, while keeping **human control** for risky or app-heavy diffs.

## Can the Cursor agent merge PRs by itself?

**Usually not directly.** Cloud agents typically have **no GitHub identity** with merge rights. Practical options:

| Approach | Who merges | Notes |
|----------|------------|--------|
| **GitHub “Enable auto-merge”** (UI) | GitHub, after checks | You click once per PR (or rely on workflow below). Needs **Settings → General → Allow auto-merge** on. |
| **This repo’s workflow** (`.github/workflows/instructions-pr-auto-merge.yml`) | GitHub Actions `GITHUB_TOKEN` | For PRs into `main`, if **every changed file** stays inside the **instruction allowlist**, the workflow calls `gh pr merge --auto --squash` so GitHub merges **when required checks pass**. No PAT. |
| **Personal access token (PAT) or GitHub App** | Bot user | Use if **branch protection** blocks `GITHUB_TOKEN` (e.g. required reviews). Store token as **Actions secret**, use `gh pr merge` in a trusted workflow. Higher setup + security duty. |
| **Local `gh pr merge`** | You | One command per PR if automation blocked. |

If `gh pr merge --auto` fails, open **Repo settings → Pull requests** and enable **Allow auto-merge**, and under **branch protection** for `main` enable **auto-merge** and either relax “required approving reviews” for bots or add a bypass rule for GitHub Actions (org policy dependent).

## Instruction-only allowlist (workflow)

Auto-merge is only attempted when the PR diff touches **only**:

- `docs/**`
- `roles/**`
- `tasks/**`
- `.cursor/**`
- `README.md` (repo root)
- `.github/workflows/instructions-pr-auto-merge.yml` (so this workflow can evolve without manual merge for every tweak)

**Anything else** (e.g. `apps/`, `lib/`, random `.github/workflows/*.yml`) → workflow **does not** enable auto-merge; **human merges** (or extend allowlist deliberately in a separate PR).

Fork PRs are ignored (`head` repo must equal this repo).

## Branching: `main` = instructions, projects on side branches

Recommended shape:

- **`main`:** Orchestration only — `docs/`, `roles/`, `tasks/`, `.cursor/`, small `README.md`, and the auto-merge workflow. Merge often; rely on path-gated auto-merge when possible.
- **`project/<slug>`** (or `app/<slug>`): Long-lived line for **one** app’s code, store assets, heavy refactors. Open PRs **to `project/<slug>`** for day-to-day agent work; merge there without touching `main`.
- **Promoting stable policy** from `main` into a project branch: merge `main` into `project/<slug>` periodically, or cherry-pick specific commits.

That way **instruction updates** land on `main` quickly (often zero-click after checks), while **app** work does not spam `main` or trigger false confidence.

Naming: keep agent branches as `cursor/<topic>-df46` for Cursor Cloud Agent compatibility if your process depends on that prefix; project branches can be `project/budget-app` etc.

## Coordinator note

When opening a PR that should auto-merge: keep diff inside allowlist; ensure **CI required checks** (if any) are green — auto-merge waits on them. For app PRs, target **`project/...`** or expect **manual** merge to `main`.
