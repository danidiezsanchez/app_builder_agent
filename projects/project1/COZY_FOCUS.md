# Cozy Focus — Project definition (Lo-Fi Pomodoro)

**Deployment:** iOS (App Store) and Android (Google Play).  
**Audience:** Women 20–35 — aesthetic, self-care, focus niche.  
**Visual:** High-fidelity warm **cozy pixel art** (immersive room scenes).  
**Monetization:** Freemium impulse IAP — **€0.90 “Zen Master”** asset pack unlocks **all paid themes** (single SKU).

**Stack:** Flutter (cross-platform UI + animation; `audioplayers` or equivalent for looped ambience + one-shot chimes/gong).

---

## Reference visuals (design lock-in)

Use these as the **strict UI targets** (paths TBD when assets land in-repo):

| Ref | Role |
|-----|------|
| `image_2.png` — Raining bedroom **idle** | Main view `IDLE` |
| `image_4.png` — Raining bedroom **countdown + pause** | Main view `FOCUS_*` / `BREAK_*` |
| `image_7.png` — “Set your flow” sketchbook modal | Three sliders overlay |
| `image_8.png` — Study fireplace **active** | Premium theme example (fireplace study) |

---

## 1. Finite state machine (FSM)

Logic must be driven by explicit states (no ad-hoc booleans for “is running”).

| State | Clock | Primary button | Sound icon | Label |
|-------|--------|----------------|------------|--------|
| `IDLE` | Start time (e.g. 25:00) | START | Off | FOCUS SESSION |
| `FOCUS_RUNNING` | Countdown | PAUSE | On / animated | FOCUS SESSION |
| `FOCUS_PAUSED` | Frozen | RESUME | Paused | FOCUS SESSION (subtle pulse optional) |
| `BREAK_RUNNING` | Countdown | PAUSE | On | REST SESSION |
| `BREAK_PAUSED` | Frozen | RESUME | Paused | REST SESSION |
| `SESSION_COMPLETE` | 00:00 | FINISH | Off | (session ended) |

**Focus:** loop **theme-matched** soundscape.  
**Break:** loop **quiet rain / white-noise** logic; play **`Chime_Start_Break.mp3` once** on entering `BREAK_RUNNING` from focus completion.  
**Optional product rule:** play **`Gong_Start_Work.mp3` once** when entering `FOCUS_RUNNING` from break (spec as event sound — wire when UX confirms).

**Session cap:** Track **cumulative focus minutes** across focus segments in the current “session.” When **accumulated focus ≥ user-set total session duration** (from Set modal), transition to `SESSION_COMPLETE` after the current focus block ends (define: end of current focus countdown vs. immediate — **recommend:** finish current focus tick, then `SESSION_COMPLETE`).

**Pomodoro loop:** IDLE → FOCUS_RUNNING ↔ FOCUS_PAUSED → (focus ends) → BREAK_RUNNING ↔ BREAK_PAUSED → (break ends) → FOCUS_RUNNING … until cap → `SESSION_COMPLETE` → FINISH → `IDLE` (reset timers to configured defaults).

---

## 2. Set flow modal (“Set your flow”)

- Trigger: **SET** on main view.  
- Presentation: modal over **slightly blurred** room.  
- Sliders (integers unless noted):

| Slider | Range | Default | Handle motif |
|--------|--------|---------|----------------|
| Work | 5–60 min | 25 | Sleepy cat |
| Break | 1–30 min | 5 | Coffee mug |
| Total session | 0.5–8.0 **hours** | 2.0 | Grandfather clock |

**Constraint:** Total session is a **ceiling on summed focus time** for the current run, not wall-clock.

---

## 3. Theme model (strict audio ↔ visual pairing)

```text
Theme = {
  id: String,
  visualAsset: String,   // bundled image path
  soundscapeAsset: String, // bundled loop for FOCUS (theme-specific)
  status: FREE | PAID,
}
```

**Rule:** Selecting a theme updates **both** background and focus-loop audio together — no independent “wallpaper vs. sound” picker for v1.

### Theme catalogue (initial)

| ID | Description | Ref / note | Status |
|----|-------------|------------|--------|
| TH01 | Raining pixel bedroom, warm lamp | `image_2` | FREE |
| TH02 | Fireplace study, books | `image_8` | FREE |
| TH03 | Glass greenhouse, plants | NEW art | FREE |
| TH04 | Cabin window, gentle snow | NEW art | FREE |
| TH05 | Beach shack, sea + sunset | NEW art | PAID |
| TH06 | Midnight desert canyon, stars | NEW art | PAID |
| TH07 | Old train compartment window | NEW art | PAID |
| TH08 | Rain-slick futuristic city (soft blur) | NEW art | PAID |
| TH09 | Ancient library alcove | NEW art | PAID |
| TH10 | Deep space viewport, distant ships | NEW art | PAID |

**Paid gate:** Free users can **tap** paid themes in Settings; show mock/real IAP sheet: *“Unlock all 10 Zen themes for €0.90?”* — no paid theme applies until purchase succeeds.

---

## 4. Audio library

| ID | File | Use |
|----|------|-----|
| SC01 | `Rain_Steady.mp3` | TH01 focus loop |
| SC02 | `Fire_Crackling.mp3` | TH02 focus loop |
| SC03 | `Forest_Ambiance.mp3` | TH03 focus loop |
| SC04 | `Snow_Silence.mp3` | TH04 focus loop |
| (paid) | One loop per TH05–TH10 | Named in asset table when produced |
| EV01 | `Chime_Start_Break.mp3` | One-shot on break start |
| EV02 | `Gong_Start_Work.mp3` | One-shot on work start (optional) |

**Break ambience:** Dedicated quiet loop (can reuse rain steady at lower gain or separate asset — **decide in implementation**; document in code).

---

## 5. Implementation task breakdown

Use this as the **first sprint ordering**; adjust labels in your tracker.

| # | Task | Outcome |
|---|------|---------|
| T1 | Flutter project + folders (`lib/`, `assets/images/`, `assets/audio/`) + `pubspec` assets | Builds empty app |
| T2 | FSM module + unit tests (transitions, illegal transitions rejected) | Timer logic without UI |
| T3 | Session engine: work/break alternation + **cumulative focus** vs. total hours cap | Correct termination → `SESSION_COMPLETE` |
| T4 | Main screen layout matching refs (clock, label, START/PAUSE/RESUME, sound toggle, SET) | Pixel-perfect pass against `image_2` / `image_4` |
| T5 | Set modal: blur + 3 sliders + persist to local storage (`shared_preferences` or Hive) | Survives restart |
| T6 | `Theme` list + Settings grid/list + selection persistence | TH01 default |
| T7 | Audio: loop soundscape on FOCUS_RUNNING; pause with FSM; resume position; one-shot chime on break | No memory leaks on hot restart |
| T8 | Placeholder / generated art for TH03–TH10 + audio stubs | Full flow demoable |
| T9 | IAP: `in_app_purchase` (or storekit/play billing wrappers) — **Zen Master** non-consumable; unlock PAID themes | Sandbox tested |
| T10 | Polish: haptics, accessibility text sizes, idle animation on sound icon | Store-ready UX pass |

**Deferred / v1.1:** notifications, widgets, stats export, additional packs.

---

## 6. Open decisions (resolve during build)

1. **Gong on work start:** on every focus segment or only first after IDLE?  
2. **SESSION_COMPLETE:** strict “stop after this focus block” vs. interrupt mid-focus when cap exceeded.  
3. **Break loop asset:** shared `Rain_Steady` vs. dedicated `Break_Quiet.mp3`.

---

*Branch: `cursor/cozy-focus-spec-f27b` — spec + task list for implementation handoff.*
