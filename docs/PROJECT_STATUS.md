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

- Created `docs/GAME_INFO.md` as the single project information entrypoint.
- Created consolidated current reference docs in `docs/reference/`.
- Rotated the previous `PROJECT_STATUS.md` and `PROJECT_WORK_LOG.md` into `docs/old/`.
- Moved previous root-level docs into `docs/old/`.
- Updated `AGENTS.md` to use the new documentation structure.

## Validation Notes

- This is a documentation-only restructuring task.
- Godot scenes, scripts, resources, assets, and `project.godot` are not intentionally changed.
- Full `git diff --check` may still report unrelated local whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`; targeted checks should be used for this docs-only change if that unrelated file remains dirty.

## Next Recommended Work

1. Use `docs/GAME_INFO.md` and `docs/reference/TECHNICAL_MAP.md` as the first-read path for the next development task.
2. GUI-check `QuarterviewMain` using the current candidate overlays and power-board interaction flow.
3. Keep future docs updates in the active three-file root plus the relevant `docs/reference/*.md` file.
