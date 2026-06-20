# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `f1efbce`
- Phase: Godot DAY 1 MVP stability testing and collision diagnosis
- Main target: Godot project under `godot/`
- Web prototype: reference only

## Current State

- DAY 1 power budget, object use, insufficient-power feedback, duplicate-use blocking, End Day, and result summary are implemented.
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
- `docs/GODOT_PLAYTEST_CHECKLIST.md`, `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`: documented the diagnostic workflow.

## Validation Results

- Local `main` was aligned with `origin/main` at task start.
- Godot 4.5.1 headless import and Main scene run completed without script or runtime errors.
- Automated scene checks passed for Test Mode toggle, modal labels, movement locking, outlet/end-day ESC cancellation, and result-screen ESC consumption.
- A rendered Test Mode capture confirmed that debug text and colored overlays are visible at `1280x720`.
- `git diff --check` passed. Web files were not modified.
- Pre-existing untracked source-side `.png.import` files remain unrelated and unstaged.
- Phone input requires user manual verification because GUI key simulation was intentionally not run.

## Current Risks Or Known Issues

- The Light model is unresolved: built-in fluorescent circuit versus plug-in Lamp.
- Reported wall/object pass-through and diagonal collision behavior is now observable but has not been redesigned or fixed in this pass.
- Dynamic adapter drag/drop, outlet hitboxes, and wire visibility still require hands-on mouse testing in Godot.
- Laptop desk-wire and several device endpoints may need small visual anchor adjustments.
- Interaction and blocker overlays require manual alignment review against the map image before collision changes are made.
- Temporary device data still lives in script constants and should move to Resources/data after MVP validation.

## Next Recommended Task

1. Run the Test Mode collision checks in `docs/GODOT_PLAYTEST_CHECKLIST.md`, especially walls, furniture, and diagonal movement.
2. Record exact blocker rectangles/ranges from the overlay, then fix only confirmed collision gaps.
3. Run the multitap hitbox and dynamic-wire checks before adding any force-state debug tools.

## Archive

- Previous accumulated status history: `docs/old/PROJECT_STATUS_20260619.md`
