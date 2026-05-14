# SPEC — Spider Solitaire MVP

## Game rules (1-suit MVP)

We ship the **1-suit** variant first. 2-suit and 4-suit unlock later under a difficulty picker (out of MVP scope).

### Deck

- **104 cards** = 2 full decks of 52.
- 1-suit MVP: every card is **♠ (spades)**. Suit field still exists in the model (so 2/4-suit can plug in later).

### Initial deal

- **10 tableau columns.**
- Columns 1–4 get **6 cards**, columns 5–10 get **5 cards** → 54 cards dealt.
- In each column, only the **top (last) card is face-up**; the rest are face-down.
- Remaining **50 cards** sit in the **stock**, dealt in 5 rounds of 10 (one card to each column) on player request.
- No separate waste/foundation piles in play — completed suits go to a **completed pile** counter.

### Legal moves

- Move a single face-up card from the top of a column onto another column if its rank is **exactly one less** than the destination's top card. Any card may be placed onto an **empty column**.
- A **run** = consecutive descending same-suit face-up cards on top of a column (e.g. 8♠ 7♠ 6♠). The whole run can be picked up and dropped on a destination whose top card is exactly one higher, **or** onto an empty column.
- When the top face-down card of a column becomes exposed (because the face-up pile above it left), flip it face-up.
- **Deal from stock** is only allowed when **no column is empty**.
- A complete **K→A same-suit run** in a single column auto-collects to the completed pile; column loses those 13 cards.

### Win condition

- **8 completed suits** collected (104 ÷ 13 = 8).

### Out of MVP scope

- Undo / hints / move animations
- Score, timer, statistics
- 2-suit / 4-suit modes (data model already supports them)
- Save / resume between app launches
- Sound, haptics, theming, settings screen

## UX shape (MVP)

- **Single screen.** Top bar: completed-suit counter + "Deal" + "New game" buttons.
- **Tableau:** 10 vertical columns of text-rendered cards (see [`CARD_RENDERING.md`](CARD_RENDERING.md)).
- **Interaction:** tap a face-up card to select; tap a destination column to drop. Selected run is the tapped card + every legal card on top of it. Illegal target → no-op + shake the selection. Drag-and-drop is **not** required for MVP.
- **No menus, no settings, no modals** except "You win!" snackbar on completion.

## Definition of "done" for MVP

- Player can play a full game of 1-suit spider end-to-end, including deal-from-stock, run moves, completed-suit collection, and win detection.
- All engine rules covered by unit tests.
- Runs on Linux desktop (`flutter run -d linux`) for dev. Mobile builds (`apk` / `ios`) deferred — only verify `flutter analyze` is clean for the mobile targets.
