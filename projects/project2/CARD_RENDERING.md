# CARD_RENDERING — text-only cards

Goal: render cards with **zero image assets**. Pure Unicode + `Text` widgets.

## Approach A (chosen for MVP): rank + suit glyph

Each face-up card is a small rounded box (8–14 px padding) showing two lines:

```
 A
 ♠
```

- Rank glyph: `A 2 3 4 5 6 7 8 9 10 J Q K`
- Suit glyph: `♠ ♥ ♦ ♣` (U+2660, U+2665, U+2666, U+2663)
- Colour: black for ♠/♣, red (`Colors.red.shade700`) for ♥/♦. For 1-suit MVP everything is black.
- Face-down card: same box, filled with a single glyph `▒` (U+2592) or `▓` (U+2593) — pick whichever renders consistently on the default Flutter font. Default to `▒`.

### Why not approach B (playing-card block U+1F0A0…U+1F0DF)

Unicode does ship full "playing card" glyphs (e.g. `🂡` = ace of spades). They look great in a terminal but:

- Inconsistent glyph coverage across Android / iOS system fonts → some show tofu.
- Single-glyph cards stack badly in a tableau column; we still need to draw a frame.
- Colour comes from the **emoji font** on some platforms; we lose control.

Approach A keeps total control over layout, colour, and overlap.

## Tableau column overlap

In a real spider tableau the lower cards peek out from under the upper cards. Implement with a `Stack` (or fixed-height `Column` with negative top margins): each card offset `~22 logical px` down from the previous so the rank+suit of every card remains visible.

```
┌────┐
│ K  │
│ ♠  │
├────┤   ← only the strip visible
│ Q  │
│ ♠  │
├────┤
│ J  │
│ ♠  │
└────┘
```

Selection state: thicken the border (`Border.all(width: 2, color: Colors.blue)`) on the selected card **and** every card below it in the same selected run.

## Sizing

- Card box: **width 36 logical px, height 52 logical px** (portrait phones fit 10 columns with 4 px gutter → 10×36 + 9×4 = 396 px which fits a 360 px-wide screen at ~0.9 scale; we accept slight horizontal scroll on the narrowest devices).
- Font: monospace (`fontFamily: 'monospace'`), size 14 for rank+suit.

## Empty column

Render an outlined dashed box of the same dimensions with a centred `·` (middle dot, U+00B7). Empty columns are valid drop targets — see [`SPEC.md`](SPEC.md).

## Completed suit indicator

Top bar shows `Completed: N / 8` and N filled `♠` glyphs.
