# Agent handoff: D4 — “Set your flow” modal (Cozy Focus)

**Branch target:** open PR **to `project1`** (app code lives on `project1`, not `main`).  
**Canonical checklist:** [`demo-build.md`](demo-build.md) → Task **D4**  
**Product detail:** [`../COZY_FOCUS.md`](../COZY_FOCUS.md) §2 (Set flow modal)

---

## Goal

Replace the **placeholder** “Set your flow” `AlertDialog` in the Flutter app with a real **modal** over a **scrimmed / slightly blurred** main view, three controls, persistence, and clear apply semantics — without implementing D5 (themes) or D6 (audio).

**Done when:**

1. **SET** (from `IDLE` only, same rule as today) opens a **modal bottom sheet** or **full-screen dialog** whose backdrop is the session screen with **BackdropFilter blur** and/or **dim scrim** (product: “slightly blurred room”).
2. Three controls (defaults match spec):

   | Control        | Range        | Default | Notes |
   |----------------|-------------|---------|--------|
   | Work           | **5–60** min (int) | 25 | `Slider` + divisions or `SliderTheme`; cat handle optional |
   | Break          | **1–30** min (int) | 5 | coffee mug handle optional |
   | Total session  | **0.5–8.0** h (double) | 2.0 | grandfather clock optional; cap = **summed focus seconds** ceiling for the run ([`COZY_FOCUS.md`](../COZY_FOCUS.md)) |

3. **CLOSE** — dismiss **without** changing engine config (discard draft values).
4. **✓ Confirm** (or “Apply”) — dismiss and call `CozyFocusSessionEngine.tryApplyConfig(CozyFocusConfig)` **only if** engine is still `idle` (method already returns `false` otherwise).

   **Apply timing (pick one, document in code + README one line):**

   - **A)** Apply immediately on confirm when `idle` (recommended: matches `tryApplyConfig` contract), **or**
   - **B)** Store “pending config” and apply on next transition to `idle` from `sessionComplete` via FINISH.

   Today’s engine only accepts apply from **`CozyFocusFsmState.idle`** — do not change that unless you extend the engine + tests.

5. **Persistence:** load/save the three values with **`shared_preferences`** (add dependency in `apps/cozy_focus/pubspec.yaml`). On cold start, engine should use saved config (construct `CozyFocusSessionEngine` with loaded `CozyFocusConfig` or call `tryApplyConfig` once after first frame when prefs ready).

6. **Widget tests:** extend `test/widget_test.dart` — open SET, drag or set slider values, confirm, assert engine/config or visible timer reflects new work duration when idle (e.g. work 6 min → `06:00` on display before START).

---

## Code map (start here)

| Area | Path |
|------|------|
| Main session UI + SET entry | `apps/cozy_focus/lib/ui/cozy_focus_session_screen.dart` (`_onSet`, placeholder dialog) |
| Config model | `apps/cozy_focus/lib/session/cozy_focus_config.dart` (`copyWith`, `sessionCapSeconds`) |
| Engine apply rule | `apps/cozy_focus/lib/session/cozy_focus_session_engine.dart` → `tryApplyConfig` |
| Library exports | `apps/cozy_focus/lib/cozy_focus.dart` |
| Existing widget tests | `apps/cozy_focus/test/widget_test.dart` |

**Dependency to add:** `shared_preferences` (Flutter team package). Run `flutter pub get` after edit.

---

## UX / layout hints

- Modal title: **“Set your flow”** (matches spec copy).
- Show current values as labels (e.g. `Work: 25 min`, `Break: 5 min`, `Session cap: 2.0 h`).
- Total session slider: use `divisions` derived from step size (e.g. 0.1 h steps → 76 steps from 0.5 to 8.0) or two steppers; avoid float equality bugs when converting to `sessionCapHours` passed to `CozyFocusConfig`.
- `CozyFocusConfig.sessionCapSeconds` uses `(sessionCapHours * 3600).round()` — document rounding for the agent who tunes cap edge cases.

---

## Out of scope (do not block D4 on)

- **D1b** modal notebook chrome image — optional; gradient + border is fine.
- **D5** theme list / Settings content.
- **D6** audio / speaker wiring.
- Changing the known **session engine** semantics unless you add tests in `test/cozy_focus_session_engine_test.dart` and update [`AGENTS.md`](../../../AGENTS.md) if behavior shifts.

---

## Verification commands

From repo root:

```bash
git checkout project1
git pull origin project1
cd apps/cozy_focus
flutter pub get
flutter test
flutter analyze
```

Resolve any **new** analyzer issues you introduce; existing `dangling_library_doc_comments` on `lib/cozy_focus.dart` may remain unless trivially fixed.

---

## PR expectations

- Small, reviewable commits; **no** unrelated refactors.
- PR description states apply-timing choice (immediate vs deferred) and prefs key names.
- Target branch: **`project1`**.

---

*Generated for parallel agent pickup; aligns with `demo-build.md` task D4.*
