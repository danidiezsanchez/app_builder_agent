# Tasks (what each agent does)

## Layout

| Path | Meaning |
|------|--------|
| [`active/`](active/) | Current work items (one file = one task). |
| [`done/`](done/) | Completed tasks (move file here when finished; keep git history). |

## Task IDs

- Pattern: **`T-0001`**, `T-0002`, …  
- Filename must match: `active/T-0007-short-slug.md`  
- **Globally unique.** Coordinator assigns next free integer.

## Lifecycle

`proposed` → `ready` → `in_progress` → `blocked` | `done`

- Only **`ready`** tasks should be picked up without Coordinator override.  
- Agent sets `status:` in frontmatter when they start/finish (if they have commit access).

## How Coordinator splits tasks

| Situation | Route | Rationale |
|-----------|--------|-----------|
| Many edits, repetitive, well-specified | **Junior** + cheap model | Volume burns tokens; skill ceiling low. |
| Unclear design, perf, security, tricky bugs | **Senior** + best model | Fewer wrong turns = cheaper than thrash. |
| Idea search, prioritization, writing specs | **Coordinator** | Keeps expensive models off prose churn. |

**Always** record in the task YAML:

- `estimated_tokens:` rough (low/med/high) — forces explicitness.  
- `role:` `coordinator` \| `senior-dev` \| `junior-dev`  
- `recommended_model:` for admin (Senior especially).

## Agent pickup rule

1. Read your **role** instructions under [`roles/`](../roles/).  
2. Open **this** task file by **ID** from `tasks/active/`.  
3. Execute; do not merge multiple IDs in one session without Coordinator OK.

## Templates

- New task: copy [`TASK_TEMPLATE.md`](TASK_TEMPLATE.md).
