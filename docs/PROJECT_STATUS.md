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

- Recorded latest generated living-space sample feedback in `docs/reference/ART_DIRECTION.md`.
- Updated `docs/GAME_INFO.md` with the new high-level sample-review summary.
- The current living-space sample is now treated as a base direction, not a failed draft.
- Next image revisions should preserve layout and Yui scale, reduce surrounding objects by about `8-15%`, adjust room footprint / wall height / door size / partition scale with the objects, pull the camera back slightly, and add a calm chill nighttime mood.
- The work / power room may use the chill night mood more strongly, while staying visually consistent with the living room and remaining centered on NAVI LINK / compact power control.
- This remains documentation-only; no image generation, scene wiring, or asset application was done.

## Validation Notes

- This is a documentation-only art direction update.
- Godot scenes, scripts, resources, assets, and `project.godot` are not intentionally changed.
- Full `git diff --check` may still report unrelated local whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`; targeted checks should be used for this docs-only change if that unrelated file remains dirty.

## Next Recommended Work

1. For the next living-space image pass, reuse the accepted sample direction and request only scale / camera / mood tuning.
2. Do not redesign the room layout unless the user explicitly asks.
3. For work + power room generation, keep the same scale/camera system and lean slightly more into the chill cyber nighttime mood.
