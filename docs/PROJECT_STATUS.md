# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Godot DAY 1 MVP Visual Pass 3 + outlet layout/slot sync fix
- Current branch: `main`
- Latest commit at task start: `67ceddc chore: track Godot UID for UI style resource`

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

## Current Goal

- Make the documented DAY 1 power loop playable, understandable, and visually closer to a dark one-room survival adventure
- Keep implementation focused on keyboard movement, proximity interaction, outlet connection, power display, object use, feedback, and result summary readiness
- Keep the presentation distinct from generic top-down survival/management games
- Prepare manual Godot editor testing of the unified power/outlet model, 2-slot devices, next-day connection visuals, and asset-ready placeholder layout

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scripts/Apartment.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scripts/ui/OutletMode.gd`
- `godot/assets/art/environment/.gitkeep`
- `godot/assets/art/objects/.gitkeep`
- `godot/assets/art/portraits/.gitkeep`
- `godot/assets/ui/icons/.gitkeep`
- `godot/assets/ui/panels/.gitkeep`
- `godot/assets/ui/fonts/.gitkeep`
- `godot/themes/.gitkeep`
- `godot/data/devices/.gitkeep`
- `docs/ASSET_PIPELINE.md`
- `docs/PROJECT_STATUS.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
- `docs/GODOT_DAY1_MVP_PLAN.md`
- `docs/GODOT_PLAYTEST_CHECKLIST.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main` before editing
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `git status --short`: checked changed Godot/docs files before staging
- `git diff --stat`: checked Godot/docs/asset-pipeline scope
- `git diff --check`: passed
- Godot execution was not run because no `godot`/`godot4` CLI or `/Applications` Godot app was available in this environment
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- Visual Pass 3 still uses primitives and placeholder drawing only; final sprites, portraits, lighting, and typography are still future work.
- Panel spacing, multitap card spacing, 2-slot device dragging, and prompt positions need another screenshot-based review in the Godot editor.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.

## Next Recommended Task

- Use `docs/GODOT_PLAYTEST_CHECKLIST.md` to test Laptop/Communication `2`-slot behavior, next-day connection visuals, and Visual Pass 3 in the Godot editor
- Capture screenshots of Exploration, Interaction, Multitap, and Result states and tune layout/readability
- Fix bugs found during manual playtesting
