# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `8c37a87`
- Phase: Godot DAY 1 MVP visual integration and live playtest preparation
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

## Current DAY 1 Decisions

- Laptop: keep at `2` outlet slots to create meaningful space pressure.
- Communication Device: keep at `1` outlet slot so DAY 1 does not become overly restrictive.
- Light: decision required. Current code treats it as a connected `1`-slot Lamp/Light, while the narrative art still reads as a built-in fluorescent ceiling light.
- Until the Light decision is resolved, current documents must distinguish implemented behavior from intended design.

## Changed Documents

- `AGENTS.md`
- `docs/PROJECT_STATUS.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/DAY1_CONTENT_BRIEF.md`
- `docs/GODOT_DAY1_MVP_PLAN.md`
- `docs/GODOT_PLAYTEST_CHECKLIST.md`
- `docs/old/PROJECT_STATUS_20260619.md`
- `docs/old/UI_VISUAL_IMPLEMENTATION_NOTES_20260619.md`
- `docs/old/ASSET_APPLICATION_NOTES_20260619.md`

## Validation Results

- Documentation-only cleanup; no Godot scripts, scenes, assets, or web files changed.
- Local `main` was aligned with `origin/main` at task start.
- Pre-existing untracked source-side `.png.import` files were not staged as part of this documentation task.

## Current Risks Or Known Issues

- The Light model is unresolved: built-in fluorescent circuit versus plug-in Lamp.
- Dynamic adapter drag/drop and wire visibility still require a live Godot playtest.
- Laptop desk-wire and several device endpoints may need small visual anchor adjustments.
- Interaction and collision overlays still require manual alignment review against the direct map image.
- Temporary device data still lives in script constants and should move to Resources/data after MVP validation.

## Next Recommended Task

1. Decide the Light model, then update code and all current DAY 1 documents together.
2. Run the multitap and dynamic-wire sections of `docs/GODOT_PLAYTEST_CHECKLIST.md` in Godot.
3. After the playtest, fix only confirmed slot, wire-anchor, or interaction-overlay issues.

## Archive

- Previous accumulated status history: `docs/old/PROJECT_STATUS_20260619.md`
