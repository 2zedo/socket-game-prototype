# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Godot DAY 1 MVP reference-based visual direction pass
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
- Applied a reference-based visual direction pass prioritizing presentation over new systems:
  - Reduced Yui's in-game scale and adjusted directional walk playback toward a smaller top-down pixel-game proportion
  - Warmed the apartment mood toward a lived-in one-room space with a readable window, implied bathroom door, desk, shelf, kitchen counter, rug, and quieter clutter
  - Repositioned key powered objects around a more natural central multitap area while preserving existing interaction and power logic
  - Removed glowing cable presentation; cables now read as simple dark wires, while powered state is communicated through device visuals
  - Enlarged the dialogue portrait presentation so Yui appears as a larger side illustration instead of a tiny face icon
  - Added subtle section separation to the multitap management overlay without changing its slot/load behavior

## Current Goal

- Make the documented DAY 1 power loop playable, understandable, and visually closer to the current reference direction: a small lived-in apartment, smaller top-down Yui sprite, restrained power-management UI, natural dark cables, and device-based powered feedback
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
- `godot/scenes/ui/InteractionPanel.tscn`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Interactable.gd`
- `godot/scripts/Player.gd`
- `godot/scripts/ui/InteractionPanel.gd`
- `godot/scripts/ui/OutletMode.gd`
- `docs/PROJECT_STATUS.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
- `docs/VISUAL_DIRECTION.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main` before editing
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `git status --short`: checked changed Godot/docs files before staging
- `git diff --stat`: checked Godot/docs visual-sanity scope
- `git diff --check`: passed
- `godot --version`: failed because no local Godot CLI/editor executable was found from the shell PATH
- Godot execution validation pending for this task because no local Godot CLI/editor executable was found from the shell
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- P0 PNG assets are now applied, but many furniture/environment details still use primitive fallback drawing.
- Yui idle/walk sprites are wired and now scaled smaller for the reference direction, but final scale/pivot still need in-editor review.
- Walk frames still use existing two walk PNGs per direction with idle frames inserted for a softer 4-frame rhythm; purpose-made 4-frame sprite art is still recommended later.
- `room_floor_base.png` and `room_wall_base.png` are drawn as underlay backdrops while existing primitive furniture/collision remains in place.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Panel spacing, compact multitap section spacing, 2-slot device dragging, enlarged dialogue portrait placement, and prompt positions need another screenshot-based review in the Godot editor.
- `comm_device_off.png` and `comm_device_on.png` now have an alpha channel, but the world view still uses a smaller primitive fallback because the current product-like perspective does not blend well with the top-down room scale.
- Several furniture pieces are improved primitives, but bed/desk/door/shelf readability will eventually benefit from purpose-built room sprites.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.

## Next Recommended Task

- Use `docs/GODOT_PLAYTEST_CHECKLIST.md` to test Yui's smaller top-down scale, object placement around the central multitap, dark cable readability, powered device feedback, Laptop/Communication `2`-slot behavior, compact multitap layout, and enlarged dialogue portrait in the Godot editor
- Capture screenshots of Exploration, Interaction, Multitap, and Result states and tune any remaining world/UI readability issues
- Fix bugs found during manual playtesting
