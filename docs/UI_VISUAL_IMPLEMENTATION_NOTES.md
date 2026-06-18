# UI Visual Implementation Notes

## Current Presentation

- The apartment uses the no-wire reference map as its visible background.
- Yui is rendered from the processed four-direction sprite sheet.
- Exploration remains keyboard-based top-down movement with proximity `E` interaction.
- Interaction, dialogue, multitap, and result UI remain separate states rather than appearing simultaneously.
- Existing UI tone remains dark brown-gray with muted brass lines and warm off-white text.

## Current Multitap UI

- The old card-selection presentation is no longer the active interaction model.
- Device connection uses draggable adapter PNGs placed into four physical slots.
- Slot occupancy and connected-device state come from `SurvivalState.gd`.
- Laptop occupies two adjacent slots and cannot begin at slot 4.
- Fan, Charger, and Communication Device currently occupy one slot each.
- Current code also presents Light/Lamp as a one-slot adapter, but that design decision is still unresolved.
- Only connected devices reveal their corresponding map wire overlays.
- Connection changes outlet load and slot occupancy; using the room object spends daily power.

## Remaining Visual Risks

- Adapter insertion masks and connected placement need live Godot review.
- Laptop desk-wire and several wire endpoints may need small anchor adjustments.
- Interaction hotspots and collision overlays need alignment review against the map art.
- Communication Device, Fan, and Laptop may eventually need dedicated world variants separate from UI preview art.
- Result presentation still needs a dedicated final survival-log skin.

## Next Visual Check

- Verify empty, one-device, Laptop two-slot, multiple-device, and disconnect states in Godot.
- Confirm each wire appears and disappears with the matching adapter state.
- Confirm no adapter or prompt overlaps the surrounding UI at the target resolution.

## Archive

- Previous visual-pass history: `docs/old/UI_VISUAL_IMPLEMENTATION_NOTES_20260619.md`
