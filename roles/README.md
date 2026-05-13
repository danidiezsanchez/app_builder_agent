# Roles (how each agent acts)

Every agent session **in order**:

1. **Identify your role** from the session brief or task file (`role:` field). If missing → stop; ask admin/Coordinator.
2. **Read this folder’s file** for that role: `roles/<role>/INSTRUCTIONS.md`.
3. **If you have a task ID** (e.g. `T-0003`) → open `tasks/active/<id>.md` (or path given in task). Do **not** invent scope outside that file.
4. **Follow** [`.cursor/rules/workflow-roles-tasks.mdc`](../.cursor/rules/workflow-roles-tasks.mdc), Karpathy rules, and project [`docs/PROJECT_PRESSURE_AND_BUDGET.md`](../docs/PROJECT_PRESSURE_AND_BUDGET.md).

## Role index

| Role folder | Purpose | Typical model tier |
|-------------|---------|-------------------|
| [`coordinator/`](coordinator/) | Ideas, backlog, split tasks, ask admin for new agents/models | Composer-class OK for planning text |
| [`senior-dev/`](senior-dev/) | Hard coding, architecture, tricky bugs — **minimize reply tokens** | Strongest / most expensive |
| [`junior-dev/`](junior-dev/) | Simple implementation, checks, refactors — **more iteration OK** | Composer 2–class, cheaper |

Coordinator maintains **which** task goes to which role; see [`tasks/README.md`](../tasks/README.md) for splitting rules.
