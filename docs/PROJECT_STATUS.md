# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Godot DAY 1 MVP P0 PNG Asset Application Pass 1
- Current branch: `main`
- Latest commit at task start: `09151cc fix: refine outlet layout and asset pipeline`

## Latest Completed Work

- `AGENTS.md` created/updated with project direction and workflow rules
- `.gitignore` updated for Godot generated files
- `README.md` updated from Vite template to project overview
- Added progress tracking and planning docs under `docs/`
- Documented visual direction and DAY 1 content direction from concept references
- Implemented the first Godot DAY 1 power loop pass
- Confirmed and tightened the top-down movement + proximity `E` interaction model
- Added visual similarity guardrails to avoid facility/task-management game resemblance
- Added an explicit bed/rest `End Day` interaction that enters the existing result summary flow
- Added upstream sync rules to avoid working on stale `main`
- Added a Godot DAY 1 MVP manual playtest checklist
- Unified the DAY 1 daily power budget with the outlet current-load model
- Made outlet connection a prerequisite for using DAY 1 power objects
- Cleaned MVP UI wording away from debug/test labels, unclear timers, and score-like result text
- Applied DAY 1 Visual Design Pass 1 to move the Godot MVP away from a clay/test-board look
- Applied DAY 1 Visual Design Pass 2 to refine screenshot-identified layout, label, panel, multitap, and result readability issues
- Tracked the Godot UID sidecar for `UIStyle.gd`
- Applied Visual Pass 3 outlet/card layout fixes, restored 2-slot Laptop/Communication device data, and prepared the asset folder pipeline
- Applied P0 PNG assets to the Godot apartment, interactable objects, player, portrait/dialogue UI, HUD power icon, and multitap slot/badge display
- Renamed several P0 PNG files that had accidental double-dot filenames so Godot paths match the documented asset pipeline

## Current Goal

- Make the documented DAY 1 power loop playable, understandable, and visually closer to a dark one-room survival adventure using controlled in-repo PNG assets
- Keep implementation focused on keyboard movement, proximity interaction, outlet connection, power display, object use, feedback, and result summary readiness
- Keep the presentation distinct from generic top-down survival/management games
- Prepare manual Godot editor testing of the unified power/outlet model, 2-slot devices, next-day connection visuals, and P0 PNG object/UI application

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scripts/Apartment.gd`
- `godot/scripts/Interactable.gd`
- `godot/scripts/Main.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scripts/ui/InteractionPanel.gd`
- `godot/scripts/ui/SurvivalHUD.gd`
- `godot/scripts/ui/AssetPaths.gd`
- P0 PNG assets under `godot/assets/art/characters/`, `godot/assets/art/environment/room/`, `godot/assets/art/objects/`, `godot/assets/art/overlays/`, `godot/assets/art/portraits/yui/`, and `godot/assets/art/ui/`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/PROJECT_STATUS.md`
- `docs/ASSET_PIPELINE.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main` before editing
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `git status --short`: checked changed Godot/docs files before staging
- `git diff --stat`: checked Godot/docs/asset-pipeline scope
- `git diff --check`: passed
- Godot execution validation pending for this task until local editor/CLI verification is run
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- P0 PNG assets are now applied, but many furniture/environment details still use primitive fallback drawing.
- `room_floor_base.png` and `room_wall_base.png` are drawn as underlay backdrops while existing primitive furniture/collision remains in place.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Panel spacing, multitap card spacing, 2-slot device dragging, and prompt positions need another screenshot-based review in the Godot editor.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.

## Next Recommended Task

- Use `docs/GODOT_PLAYTEST_CHECKLIST.md` to test Laptop/Communication `2`-slot behavior, next-day connection visuals, and P0 PNG state changes in the Godot editor
- Capture screenshots of Exploration, Interaction, Multitap, and Result states and tune layout/readability
- Fix bugs found during manual playtesting
