# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Godot DAY 1 MVP visual sanity pass
- Current branch: `main`
- Latest commit at task start: `1f91c20 style: normalize Godot PNG layout`

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
- Replaced the single Yui player texture display with directional idle/walk `AnimatedSprite2D` visuals while preserving movement, collision, and interaction logic
- Normalized current PNG world display scale/offset/z-index rules and tightened the multitap card grid so cards no longer share the same cramped slot space
- Applied a visual sanity pass to enlarge Yui's visual display, reduce oversized world objects, improve primitive furniture readability, soften cable/light presentation, and simplify the multitap slot/card layout

## Current Goal

- Make the documented DAY 1 power loop playable, understandable, and visually closer to a dark one-room survival adventure using controlled in-repo PNG assets, direction-aware Yui animation, consistent world/UI scale rules, and less cluttered multitap UI
- Keep implementation focused on keyboard movement, proximity interaction, outlet connection, power display, object use, feedback, and result summary readiness
- Keep the presentation distinct from generic top-down survival/management games
- Prepare manual Godot editor testing of Yui directional animation together with the unified power/outlet model, 2-slot devices, next-day connection visuals, P0 PNG object/UI application, and screenshot-based layout tuning

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scenes/Player.tscn`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Interactable.gd`
- `godot/scripts/ui/OutletMode.gd`
- `docs/PROJECT_STATUS.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main` before editing
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `git status --short`: checked changed Godot/docs files before staging
- `git diff --stat`: checked Godot/docs visual-sanity scope
- `git diff --check`: passed
- Godot execution validation pending for this task because no local Godot CLI/editor executable was found from the shell
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- P0 PNG assets are now applied, but many furniture/environment details still use primitive fallback drawing.
- Yui idle/walk sprites are wired and visually enlarged again, but final scale/pivot still need in-editor review.
- Walk frames are temporary and expected to be replaced or tuned later.
- `room_floor_base.png` and `room_wall_base.png` are drawn as underlay backdrops while existing primitive furniture/collision remains in place.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Panel spacing, compact multitap card spacing, 2-slot device dragging, and prompt positions need another screenshot-based review in the Godot editor.
- `comm_device_off.png` and `comm_device_on.png` now have an alpha channel, but the world view still uses a smaller primitive fallback because the current product-like perspective does not blend well with the top-down room scale.
- Several furniture pieces are improved primitives, but bed/desk/door/shelf readability will eventually benefit from purpose-built room sprites.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.

## Next Recommended Task

- Use `docs/GODOT_PLAYTEST_CHECKLIST.md` to test Yui visual scale, object scale/position, Laptop/Communication `2`-slot behavior, compact multitap layout, next-day connection visuals, and P0 PNG state changes in the Godot editor
- Capture screenshots of Exploration, Interaction, Multitap, and Result states and tune any remaining world/UI readability issues
- Fix bugs found during manual playtesting
