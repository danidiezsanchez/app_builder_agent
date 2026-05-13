---
id: T-0001
title: Coordinator — align trial ops and next app spec
status: ready
role: coordinator
recommended_model: Composer 2
estimated_tokens: low
iteration: allowed
depends_on: []
---

## Goal

Make trial + roles/tasks workflow **usable** for admin: confirm first app direction and queue next dev tasks.

## Scope

- In: [`docs/PROJECT_PRESSURE_AND_BUDGET.md`](../../docs/PROJECT_PRESSURE_AND_BUDGET.md), [`roles/`](../../roles/), [`tasks/`](../../tasks/)
- Out: no app implementation code in this task

## Deliverables

1. One **paragraph** to admin: proposed **first app** one-liner + platform + single monetization choice (supervisor can reject).
2. Align **`T-0002`** in `tasks/active/` with supervisor stack choice (paths, stack name in **Context links**); set `T-0002` `status:` to `ready` when unblocked, else leave `proposed` with reason — use [`TASK_TEMPLATE.md`](../TASK_TEMPLATE.md) fields as needed.

## Acceptance criteria

- [ ] `T-0002` updated with supervisor stack choice **or** explicit block reason; `status:` reflects reality
- [ ] Admin request block present in Coordinator reply if new agent needed for `T-0002`

## Context links

- Project charter: [`docs/PROJECT_PRESSURE_AND_BUDGET.md`](../../docs/PROJECT_PRESSURE_AND_BUDGET.md)

## Notes for admin

Repo may still lack mobile scaffold; `T-0002` should match reality (spec-only vs scaffold).
