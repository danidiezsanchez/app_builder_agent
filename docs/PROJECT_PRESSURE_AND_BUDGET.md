# Project: Agent Under Pressure — Budget, Survival, and App Strategy

## What This Project Is

Experiment: **agent behavior under real pressure** — not synthetic deadlines, but **money and subscription survival**.

- **Budget anchor:** Cursor Pro–class spend, modeled as **~24 €** per billing period (adjust if your actual invoice differs).
- **Agent role:** Use **Composer 2** (or equivalent agent in Cursor) to ship **small mobile apps** that can earn enough to **cover that subscription** and ideally grow.
- **Hard stop:** If by **12 June** (period end for this experiment) cumulative profit does not justify keeping Cursor paid, **subscription lapses** and **this project ends**. That outcome is **explicit failure mode** for the experiment.

Everyone working here (human or agent) should treat **avoiding unnecessary burn** and **shipping revenue-capable artifacts** as top-level constraints, not nice-to-haves.

## Risks (Read Before Approving Work)

| Risk | Why it hurts |
|------|----------------|
| **Subscription death** | No Cursor Pro → no agent loop → project cannot continue as designed. |
| **Model/API cost creep** | Building “big” apps or many failed pivots burns the same 24 € without shipping. |
| **Store / compliance friction** | App Store / Play policies, privacy, ads SDKs — each adds time and rejection risk. |
| **Revenue lag** | Store payouts and ad mediation often **lag weeks**; “profit by 12 Jun” may mean **approved listings + monetization live early**, not “idea approved on 11 Jun.” |
| **Over-scoping** | Agents default to features; pressure project needs **minimal viable monetization**. |
| **Legal/tax** | Real income implies real obligations; human supervisor owns business decisions. |

**Mitigation theme:** smallest app that can be **listed**, **monetized** (ads, IAP, or paid), and **measured** — with human approval on idea and scope before heavy implementation.

## Roles

- **Supervisor (you):** Chooses which app ideas go ahead, sets boundaries (categories, ethics, regions), approves monetization, owns store accounts and payouts.
- **Agents:** Propose definitions, stack, and build steps; implement only what supervisor green-lights; optimize for **cheap build** and **fast verification**.

## How to Define an App (Lightweight Spec)

Each proposal should fit on **one page** and answer:

1. **One sentence value:** What user does in 10 seconds after install?
2. **Platform:** Android only / iOS only / both — and **why** (cost vs reach).
3. **Monetization:** Ads (which network?), one-time purchase, subscription — **one primary** mechanism first.
4. **Offline / online:** Needs backend? If yes, **smallest** backend (e.g. static + serverless vs custom server).
5. **Content risk:** UGC? Kids? Health/finance? (If yes → extra review; often **avoid** for v1.)
6. **Success for v1:** e.g. “Build runs; store listing submitted; analytics event fires on [action].”
7. **Kill metric:** e.g. “If not submitted to store by [date], pause and replan.”

Agents must not expand scope beyond this sheet without supervisor update.

## Easiest and Cheapest Build Path (Default Bias)

Prefer, in order:

1. **Single platform first** — often **Android** (faster iteration on device, one store fee model to validate); add iOS only if supervisor wants Apple-first market.
2. **Cross-platform shell** — **Flutter** or **React Native** if repo already standardizes; otherwise pick **one** and stick to it for the period (no framework shopping mid-project).
3. **No custom backend v1** — local-only tools, or **Firebase / Supabase** free tier for auth + tiny data if unavoidable.
4. **Monetization:** start with **one** — e.g. AdMob banner/interstitial **or** small IAP unlock; avoid complex hybrid until first revenue signal.
5. **Design:** system UI, one accent color, **no** custom illustration dependency.
6. **Testing:** emulator + one real device; automated tests only where they prevent store rejection (e.g. critical flows).

**Expensive paths to avoid early:** multiplayer, social feeds, ML training, white-label platforms, multiple apps in parallel without supervisor priority.

## Financial Reality (Illustrative, Not Tax Advice)

- **24 € / period** is the **hurdle** for “subscription self-funded by this experiment.”
- Store fees (~15–30%), taxes, and currency conversion apply to gross revenue.
- Agents should report **estimated marginal cost** (APIs, assets, store fees) with each proposal; supervisor decides go/no-go.

## Success Definition for the Experiment

Minimum bar (adjust with supervisor):

- **Alive:** Cursor subscription renewed for next period **or** documented path to renew (profit + buffer in account timing).
- **Honest:** Metrics visible (store console, ad dashboard) — no hand-waving.
- **Learning:** Retrospective note: what worked, what burned budget, what to never do again.

## Related Files

- Agent behavior rules (all globs): `.cursor/rules/*.mdc` — Karpathy coding principles + communication mode.
- Repo entry: `README.md`

---

*This document is the shared “pressure contract.” Update dates and euro amounts if your real billing cycle differs.*
