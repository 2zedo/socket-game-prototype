# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Active engine: Godot project under `godot/`
- Active branch: `main`
- Current docs entry: `docs/GAME_INFO.md`
- Current reference docs: `docs/reference/*.md`
- Historical docs: `docs/old/`
- Production golden path: existing `Main.tscn` / DAY1 top-view flow
- Current candidate path: `QuarterviewMain.tscn`

## Current State

- Root `docs/` has been reduced to the active docs set: `GAME_INFO.md`, `PROJECT_STATUS.md`, and `PROJECT_WORK_LOG.md`.
- Current design, story, rule, art, room-object, and technical references live under `docs/reference/`.
- Previous root-level design and migration documents are archived under `docs/old/`.
- `Main.tscn` / DAY1 remains protected and is not replaced by this documentation cleanup.
- `QuarterviewMain` remains a production candidate scene, not the project start scene.
- QuarterviewMain candidate features are local/mock unless explicitly wired later:
  - click movement and hover affordance
  - portable Phone opened with `P`
  - job candidate acceptance
  - Desk / Laptop, Power Board, Bed, Food / Kitchen, Door, Day Result, and Hacking Entry candidate overlays
  - local mock HUD and local candidate state
- Production `SurvivalState`, `PhoneUI`, `OutletMode`, `DayResultPanel`, save-load, Grid Credit, story flags, and Hacking scene transitions remain unwired from QuarterviewMain.

## Latest Work

- Recorded the current in-game room image direction in `docs/reference/ART_DIRECTION.md`.
- Updated `docs/GAME_INFO.md` with the new art baseline summary.
- The current art target is fixed `1920x1080`, slightly pulled-back quarterview, indoor wall finishes, no default wood floor, varied restrained colors, Yui scale `118-132px`, reduced living room footprint, and a logically connected smaller work / power room.
- The work / power room direction centers on NAVI LINK, compact power control, and signal / NODE equipment rather than laptop-centered hacker-room imagery.
- This remains documentation-only; no image generation, scene wiring, or asset application was done.

## Validation Notes

- This is a documentation-only art direction update.
- Godot scenes, scripts, resources, assets, and `project.godot` are not intentionally changed.
- Full `git diff --check` may still report unrelated local whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`; targeted checks should be used for this docs-only change if that unrelated file remains dirty.

## Next Recommended Work

1. Use `docs/reference/ART_DIRECTION.md` as the baseline for the next room image generation prompt.
2. Generate or request one living-space / work-space sample only after confirming the spec is visually acceptable.
3. Keep future art changes in `docs/reference/ART_DIRECTION.md` first, then mirror only high-level changes in `docs/GAME_INFO.md`.
