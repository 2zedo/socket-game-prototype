# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `c621bc9`
- Phase: Godot DAY 1 MVP hourly active-power tuning
- Main target: Godot project under `godot/`
- Web prototype: reference only

## Current State

- DAY 1 separates outlet connection from device active state; connected devices can be switched on/off and only active time drains the daily budget.
- Yui uses a processed four-direction walk sheet based on `docs/reference/yui-1.png`.
- The apartment uses `map_base_no_wires.png` as its visible base map.
- The multitap screen uses draggable adapter PNGs rather than card-based device selection.
- `SurvivalState.gd` is the source of truth for slot occupancy, connected devices, outlet load, and daily power state.
- Connected devices reveal their matching map wire overlays; disconnected devices keep those overlays hidden.
- Laptop occupies two adjacent slots and cannot start from slot 4.
- Communication Device currently occupies one slot.
- Pressing `P` toggles a developer Test Mode with gameplay-state text and collision/interaction overlays.
- Modal input is routed through `Main.gd`; movement is locked while interaction, outlet, end-day, phone, or result UI is active.
- `Tab` opens the existing Phone UI during exploration; it closes with `Tab` or `ESC` and locks Yui movement while visible.
- The Phone UI clock maps the existing 60-second day timer from `08:00` to `20:00`; normal HUD clock details stay hidden.
- Apartment outer-wall collision now follows the walkable floor inside the map art, with overlapping corners to prevent diagonal escape gaps.
- Exploration hides the left status HUD; Phone UI is the primary status view while prompts, controls, and Test Mode remain visible.
- The in-game clock advances only during free exploration and pauses for Phone, Outlet, Interaction, End Day, and Result modals.
- Room objects can be activated by left-clicking their existing interaction rectangle while Yui is within the same proximity range used by `E`; room clicks are ignored while a modal is open.
- Interaction panels expose clickable use and cancel/close buttons that reuse the existing `E` and `ESC` action paths.
- Interaction buttons brighten their border on hover/press; informational panels without a primary action close with either `E`, `ESC`, or the close button.
- Informational interaction panels label their shared close action as `[E / ESC] 닫기`.
- Outlet dragging highlights only the targeted existing slot hitbox: green for a valid drop and red for an invalid drop, with two-slot adapters spanning both affected slots.
- Normal outlet presentation hides slot borders and exposes the PNG's built-in green LED only for occupied slots; empty-slot LEDs are darkened while drag-time feedback remains separate.
- Connected adapters no longer retain a selection-like border after placement; borders remain limited to active drag feedback and Test Mode diagnostics.
- Outlet preview and drop now resolve the same target slot, preventing valid two-slot Laptop feedback from disagreeing with placement.
- Connected adapter placement exposes per-device offset and scale tuning while retaining the previous zero-offset/unit-scale defaults.
- Phone battery warnings appear once per day when battery crosses `20%`, `10%`, `5%`, and `0%`.
- At `0%`, Phone UI remains accessible but hides status details until charging restores the battery.
- Active drain uses per-game-hour tuning: Light `0.5`, Laptop `3.0`, Fan `1.0`, Charger `1.0`, and Communication Device `2.0` units per game hour.
- The `60`-second playable day maps to `12` game hours; first activation records use without blocking later toggles.
- Disconnecting a device clears its active state, while map wire overlays continue to follow connection state.
- Phone UI is a current-status view only: time, period, battery, remaining power, hourly drain, and active devices. Historical use remains exclusive to Result.

## Current DAY 1 Decisions

- Laptop: keep at `2` outlet slots to create meaningful space pressure.
- Communication Device: keep at `1` outlet slot so DAY 1 does not become overly restrictive.
- Light: decision required. Current code treats it as a connected `1`-slot Lamp/Light, while the narrative art still reads as a built-in fluorescent ceiling light.
- Until the Light decision is resolved, current documents must distinguish implemented behavior from intended design.

## Changed Files

- `godot/project.godot`: added Test Mode, reserved phone, and shared cancel input actions.
- `godot/scripts/Main.gd`: centralized Test Mode and modal input routing.
- `godot/scripts/Apartment.gd`: added collision, interaction, nearest-object, and wire-anchor overlays.
- `godot/scripts/ui/OutletMode.gd`: added slot/adapter debug overlays and delegated ESC handling to `Main.gd`.
- `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: added the Test Mode status/readout.
- `godot/scenes/ui/PhoneUI.tscn`: updated the reserved phone key hint to `Tab`.
- `godot/scripts/Main.gd`: routes `open_phone` plus a raw `KEY_TAB` edge through the existing Phone UI toggle and logs each received toggle.
- `godot/scripts/SurvivalState.gd`: provides the Phone UI clock text and daytime period while the HUD omits those details.
- `godot/scripts/Apartment.gd`: aligns only the four outer wall blockers to the interior floor boundary.
- `godot/scenes/ui/SurvivalHUD.tscn`, `godot/scripts/ui/SurvivalHUD.gd`: hide exploration status panels and their power icon.
- `godot/scripts/Main.gd`, `godot/scripts/SurvivalState.gd`: pause only the display clock while modal UI is active.
- `godot/scripts/Main.gd`: routes eligible left-clicks through the existing nearest-interactable request used by `E`.
- `godot/scenes/ui/InteractionPanel.tscn`, `godot/scripts/ui/InteractionPanel.gd`, `godot/scripts/Main.gd`: connect real panel buttons to the existing confirm and cancel handlers.
- `godot/scripts/ui/InteractionPanel.gd`: adds distinct hover/pressed feedback while preserving existing button actions.
- `godot/scripts/ui/InteractionPanel.gd`: aligns the no-primary-action hint with its existing `E` and `ESC` close behavior.
- `godot/scripts/ui/OutletMode.gd`: draws valid/invalid drag feedback above the power-strip art without changing slot coordinates or connection rules.
- `godot/scripts/ui/OutletMode.gd`: maps occupancy onto the existing LED artwork in `powerstrip_4slot.png` without adding new LED shapes.
- `godot/scripts/ui/OutletMode.gd`: removes the normal connected-adapter outline while preserving drag feedback.
- `godot/scripts/ui/OutletMode.gd`: shares one target-slot resolver between drag preview and actual drop.
- `godot/scripts/ui/OutletMode.gd`: centralizes connected visual offset/scale tuning for Fan, Charger, Communication Device, Lamp, and Laptop.
- `godot/scripts/SurvivalState.gd`, `godot/scripts/Main.gd`: track daily battery-warning thresholds and route warning messages to the HUD.
- `godot/scripts/ui/SurvivalHUD.gd`, `godot/scenes/ui/SurvivalHUD.tscn`: show short battery warnings above the screen center.
- `godot/scripts/SurvivalState.gd`: defines hourly device drain, converts elapsed real time to game hours, and exposes decimal remaining power plus current active drain.
- `godot/scripts/Main.gd`: shows hourly drain and decimal remaining power in interaction and Test Mode readouts.
- `godot/scripts/SurvivalState.gd`: removes first-use history and unrelated daily summary fields from Phone text while preserving Result data.
- `docs/GODOT_PLAYTEST_CHECKLIST.md`, `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`: documented the diagnostic workflow.

## Validation Results

- Local `main` was aligned with `origin/main` at task start.
- Godot 4.5.1 headless import and Main scene run completed without script or runtime errors.
- Automated scene checks passed for Test Mode toggle, modal labels, movement locking, outlet/end-day ESC cancellation, and result-screen ESC consumption.
- A rendered Test Mode capture confirmed that debug text and colored overlays are visible at `1280x720`.
- `git diff --check` passed. Web files were not modified.
- Godot 4.5.1 headless editor initialization completed after adding mouse interaction routing.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after converting interaction controls to clickable buttons.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after adding interaction-button hover feedback.
- Godot 4.5.1 headless Main scene startup completed after updating the interaction close hint.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after the outlet drag-feedback change.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after replacing normal slot borders with LEDs.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after mapping occupancy to the PNG's built-in LEDs.
- Godot 4.5.1 headless Main scene startup completed after removing connected-adapter borders.
- Godot 4.5.1 headless Main scene startup completed after unifying outlet preview/drop target selection.
- Godot 4.5.1 headless editor initialization and Main scene startup completed after exposing connected-adapter tuning values.
- Godot 4.5.1 headless Main scene startup completed after adding Phone battery warnings and the empty-battery view.
- Godot 4.5.1 headless Main scene startup completed after separating connected and active power states.
- Godot 4.5.1 headless Main scene startup completed after converting active drain to per-game-hour units.
- Pre-existing untracked source-side `.png.import` files remain unrelated and unstaged.
- Phone input requires user manual verification because GUI key simulation was intentionally not run.

## Current Risks Or Known Issues

- The Light model is unresolved: built-in fluorescent circuit versus plug-in Lamp.
- Reported wall/object pass-through and diagonal collision behavior is now observable but has not been redesigned or fixed in this pass.
- Dynamic adapter drag/drop, outlet hitboxes, and wire visibility still require hands-on mouse testing in Godot.
- Laptop desk-wire and several device endpoints may need small visual anchor adjustments.
- Interaction and blocker overlays require manual alignment review against the map image before collision changes are made.
- Mouse interaction requires manual checks for all six room targets and out-of-range clicks; no GUI input simulation was run.
- Interaction-panel button clicks require manual confirmation; GUI input simulation was intentionally not run.
- Interaction-button hover colors require manual visual confirmation; no GUI or screenshot validation was run.
- Outlet valid/invalid colors and two-slot span feedback require manual drag confirmation; connection logic was not changed.
- Outlet LED off/on states, including two-slot Laptop occupancy, require manual visual confirmation.
- Built-in LED mask alignment and two-slot LED exposure require manual visual confirmation at the target resolution.
- Two-slot Laptop drops require manual checks at valid starts 1-3 and invalid start 4.
- Temporary device data still lives in script constants and should move to Resources/data after MVP validation.
- Battery-warning timing, daily one-shot behavior, the `0%` Phone view, and recovery after charging require manual GUI confirmation.
- Continuous drain rate, modal pause, repeated on/off control, disconnect shutdown, and zero-power shutdown require manual gameplay confirmation.
- Hourly drain totals and one-decimal Phone display require manual timing confirmation, especially Laptop-only and Laptop-plus-Fan cases.
- Phone current-status-only content and unchanged Result history require manual GUI confirmation.

## Next Recommended Task

1. Verify Laptop reports `-3.0 / h`, Laptop plus Fan reports `-4.0 / h`, and remaining power drops at the game-hour rate.
2. Confirm hourly drain pauses in every modal and stops all devices safely at zero power.
3. Verify Phone shows no historical use list while Result retains first-activation history.

## Archive

- Previous accumulated status history: `docs/old/PROJECT_STATUS_20260619.md`
