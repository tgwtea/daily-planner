# Sync conflict

Status: Planned
Artboards: 3ag
Features: [Calendar views and events](../features/calendar-views-and-events.md#two-way-sync)

## Purpose

Ask which time wins when a synced block changed in Apple Calendar.

## Layout

A glass dialog over Today: title "Gym changed in Calendar", body "It was moved to 5:00 PM in Apple Calendar. Here it's still at 4:00 PM. Which should stay?", and three stacked buttons: "Use 5:00 PM" (primary), "Keep 4:00 PM", "Stop syncing this block".

On Today, the block shows a triangle-alert glyph and the meta "4:00 – 5:00 · Changed in Calendar" in `status-warning`. A tap on it opens this dialog.

## Interactions

- "Use 5:00 PM": the block moves. Toast "Gym moved to 5:00 PM".
- "Keep 4:00 PM": the calendar copy moves back. Toast "Kept 4:00 PM · Calendar updated".
- "Stop syncing this block": the block becomes local only. Toast "Gym is local only now".

## Open questions

None.
