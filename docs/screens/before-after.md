# Before and after

Status: Planned
Artboards: 3o
Features: [Running-late nudge](../features/running-late-nudge.md)

## Purpose

Show the effect of a suggested change before the user applies it.

## Layout (top to bottom)

A glass sheet:

1. Hourglass and "Running long". Title "Adjust the afternoon?". Body: "You're still focusing on the SwiftUI timeline. This keeps fixed and protected time where it is."
2. Column headers "Now" and "Suggested".
3. One row per affected block: a small pill (color, or dashed for Open time), the title with a glyph (lock, shield), a note ("Flexible", "Ends 3:00, no buffer", "Fixed · unchanged", "Protected · unchanged", "Unchanged"), the old time (struck through when it changes), and the new time (bold when it changes, tertiary when not).
4. A primary "Move 2 blocks" and a ghost "Keep as is".

## Navigation

- Opened by "Preview" on the running-late nudge. "Keep as is" or a scrim tap closes it.

## Interactions

- "Move N blocks" applies the moves, hides the nudge for that block, and shows a toast ("Lunch 12:30 · Study 1:30").

## Accessibility and iOS notes

- Each row reads "Lunch, 12:00 to 12:30, flexible".

## Open questions

None.
