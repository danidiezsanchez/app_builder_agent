# Cozy Focus — Demo build tasks

**Canonical spec:** [`../COZY_FOCUS.md`](../COZY_FOCUS.md)  
**Goal:** A **single installable Flutter demo** (iOS Simulator + Android Emulator) that proves the core loop: FSM-driven timer, themed room + matched ambience, “Set your flow” modal, break chime, cumulative focus cap → `SESSION_COMPLETE`, and a **mock** paid-theme gate (no real store billing required for the demo).

**Demo scope (intentionally smaller than v1 ship):**

| Area | Demo | Full product (later) |
|------|------|----------------------|
| Themes | **TH01 + TH02** fully wired (visual + loop). Optional: other themes as **same duplicate asset** with different labels for UI testing only. | TH01–TH10 unique art + audio |
| IAP | **Mock sheet** only (tap “Unlock” sets `zenMasterOwned = true` in memory or local prefs) | `in_app_purchase` + store products |
| Session length | Default **2 h** cap OK; add **dev-only** “short cap” (e.g. **3 min** total focus) toggle or build flavor so QA hits `SESSION_COMPLETE` quickly | Production defaults only |
| Polish | Skip App Store screenshots, analytics, accessibility audit | Full polish pass |

---

## Escalation: when the implementing agent cannot create an asset

Use this **copy-paste request** to the human (designer / product). Replace bracketed fields.

```text
Subject: Cozy Focus demo — assets needed

Please add files to the repo (or zip) at the paths below. The Flutter demo cannot ship without them or without explicit approval to use placeholders.

Requested by: [agent / developer name]
Branch: [branch name]

| Path (under apps/cozy_focus/assets/ or agreed tree) | Format | Spec |
|-----------------------------------------------------|--------|------|
| … | … | … |
```

**Rules for agents:**

- **Do not** invent royalty-free audio licenses; if you cannot verify license, **stop** and send the request block with links to sources you need approved.
- **Pixel backgrounds:** If you cannot produce on-brand pixel art, use **temporary** `Container` gradients + text watermark **“PLACEHOLDER — replace with TH0X”** only inside **debug/demo** builds, and list the real files in the request table.
- **Audio:** For silent CI or layout-only builds, you may use **empty** loops only if the code path still calls `AudioPlayer` with a **1-frame** silent asset you generate in-repo (WAV/OGG) and document it as **non-shipping**.

---

## Task D0 — Flutter shell & project layout

**Owner:** implementer agent  
**Done when:** `flutter run` launches a blank themed `MaterialApp` / `CupertinoApp` on iOS + Android.

**Steps:**

1. Create app directory (suggest): `apps/cozy_focus/` (or `projects/project1/app/` — pick one convention and document in app `README.md`).
2. Add `assets/images/`, `assets/audio/`, declare in `pubspec.yaml`.
3. Add `flutter_lints` (or project standard), `README` with run commands.

**No external inputs required.**

---

## Task D1 — Asset pack (blocking for “real” demo)

**Owner:** implementer OR human designer  
**Done when:** All rows below exist as **bundled** assets referenced by `pubspec.yaml`.

### D1a — Visual backgrounds (pixel art)

| ID | File name (suggested) | Notes | If missing |
|----|------------------------|-------|------------|
| TH01 | `th01_rain_bedroom.png` | Match mood: warm lamp, rain **idle + running use same still** for demo | Request: export **9:16** or **1170×2532** (or vector @1x/@2x/@3x set). Reference: raining bedroom mock in product deck. |
| TH02 | `th02_fireplace_study.png` | Fireplace study scene | Same as above. |

**Request template snippet (images):**

```text
| assets/images/th01_rain_bedroom.png | PNG, @3x ~1170×2532 portrait | Cozy pixel rain bedroom — warm interior, window rain |
| assets/images/th02_fireplace_study.png | PNG | Cozy pixel study + lit fireplace |
```

### D1b — Modal chrome (optional for demo)

| File | Notes | If missing |
|------|-------|------------|
| `set_flow_modal_bg.png` | Spiral notebook / paper | Use `DecoratedBox` + `BorderRadius` + noise texture **or** request from designer referencing `image_7` in spec. |

### D1c — Audio

| ID | File | Role | If missing |
|----|------|------|------------|
| SC01 | `Rain_Steady.mp3` | Focus loop TH01 | Request: **seamless loop** 30–60 s, normalized LUFS ~-16, no vocals. Royalty-free link or original export. |
| SC02 | `Fire_Crackling.mp3` | Focus loop TH02 | Same. |
| EV01 | `Chime_Start_Break.mp3` | One-shot on `BREAK_RUNNING` enter | Request: **short** (<2 s) gentle chime, non-looping. |
| (break bed) | `Rain_Steady.mp3` reused at **-12 dB** **or** `Break_Quiet.mp3` | Break ambience loop | Agent may **reuse SC01** with gain for demo; document in code. |

**Optional (spec EV02):**

| EV02 | `Gong_Start_Work.mp3` | One-shot when entering focus | Omit in demo if not ready; gate with a `const bool kPlayGong = false`. |

**Request template snippet (audio):**

```text
| assets/audio/Rain_Steady.mp3 | MP3 320kbps or AAC | Seamless rain loop |
| assets/audio/Fire_Crackling.mp3 | MP3 | Seamless fire loop |
| assets/audio/Chime_Start_Break.mp3 | MP3 | Single hit, no tail clipping |
```

---

## Task D2 — FSM + session engine (no UI)

**Owner:** implementer agent  
**Done when:** Unit tests cover legal transitions and reject illegal ones; cumulative focus minutes drive `SESSION_COMPLETE` per [`COZY_FOCUS.md`](../COZY_FOCUS.md) recommendation (finish current focus slice, then complete).

**Inputs:** None (pure Dart).

**Suggested tests:**

- `IDLE` → `FOCUS_RUNNING` → `FOCUS_PAUSED` → `FOCUS_RUNNING` → end countdown → `BREAK_RUNNING` (assert chime callback fired once).
- After N short work segments, assert transition to `SESSION_COMPLETE` when cumulative focus ≥ cap.
- `SESSION_COMPLETE` → `FINISH` → `IDLE` resets clock to configured work duration.

---

## Task D3 — Main screen UI (timer + buttons + label)

**Owner:** implementer agent  
**Done when:** Layout matches product intent: large `MM:SS`, label (`FOCUS SESSION` / `REST SESSION` / complete), bottom row **PAUSE**/**RESUME**/**START** + **SET** + **SETTINGS**, speaker icon, optional gear (can duplicate Settings entry).

**Inputs:** D1a images (or placeholders behind `kDebugMode`).

---

## Task D4 — “Set your flow” modal

**Owner:** implementer agent  
**Done when:** SET opens modal with blurred/scrimmed room; three controls:

- Work 5–60 min (default 25), cat handle **or** simple `SliderTheme`.
- Break 1–30 min (default 5).
- Total session 0.5–8.0 h (default 2.0) — use `Slider` + ` divisions` or `CupertinoPicker`; **+ / −** step buttons optional.

Persist with `shared_preferences` (or Hive). **CLOSE** + **✓ confirm** dismiss and apply on next `IDLE` or immediately if spec says so (pick one, document).

**Inputs:** D1b optional.

---

## Task D5 — Theme list + strict pairing + mock IAP

**Owner:** implementer agent  
**Done when:**

- Data model matches `Theme { id, visualAsset, soundscapeAsset, status }`.
- Selecting TH01/TH02 swaps **both** image and focus loop asset.
- Tapping a **PAID** row (e.g. TH05 placeholder) shows dialog: *“Unlock all 10 Zen themes for €0.90?”* with **Cancel** / **Unlock (demo)**; demo unlock flips global flag and enables selection.

**Inputs:** None beyond D1.

---

## Task D6 — Audio wiring

**Owner:** implementer agent  
**Done when:**

- `FOCUS_RUNNING`: play theme loop; mute icon stops **or** pauses loop (match spec: icon reflects state).
- `FOCUS_PAUSED` / `BREAK_PAUSED`: pause at position.
- Enter `BREAK_RUNNING` from focus end: play EV01 **once**; start break bed loop.
- Dispose players on `dispose` / state teardown (no leak on hot restart).

**Package:** `audioplayers` or `just_audio` — pick one, document why.

**Inputs:** D1c files.

---

## Task D7 — Demo “done” checklist (manual QA)

| # | Action | Expected |
|---|--------|----------|
| 1 | Fresh install, tap START | TH01 rain + `Rain_Steady` loop |
| 2 | PAUSE / RESUME | Timer + audio freeze correctly |
| 3 | Let focus end | Chime once, break label, quieter loop |
| 4 | SET → change work to 6 min, total cap to 0.1 h | After enough cycles, `SESSION_COMPLETE` + FINISH returns to IDLE |
| 5 | SETTINGS → TH02 | Room + fire audio together |
| 6 | SETTINGS → paid theme | Mock unlock flow |

---

## Ordering for agents (parallelism)

```text
D0 → (D1 ∥ D2) → D3 → D4 → D5 → D6 → D7
```

`D1` and `D2` can run in parallel on two agents; **D3+** need at least placeholder assets from **D1**.

---

## Single-agent minimal path (if assets arrive late)

1. Complete **D0 + D2** first.  
2. **D3** with **solid-color** backgrounds + visible theme ID text.  
3. **D6** with **silent** or **system beep** stub behind `kUseAudioStubs` until files land.  
4. Swap stubs for real assets without changing FSM.

---

*Last updated: aligns with `COZY_FOCUS.md` on branch `project1`.*
