# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: YUI-1 player sprite replacement pass
- Current branch: `main`
- Latest commit at task start: `be999d9 feat: apply reference apartment map and YUI sprite assets`

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
- Added persistent `AGENTS.md` workflow rules for startup checks, document-specific update criteria, meaningful work-unit closeout, and final report structure
- Aligned `PROJECT_STATUS.md` with the new documentation workflow rules without adding new tracking documents
- Reconfirmed that `ROADMAP.md`, `GODOT_DAY1_MVP_PLAN.md`, `UI_VISUAL_IMPLEMENTATION_NOTES.md`, `ASSET_APPLICATION_NOTES.md`, and `YUI_ANIMATION_NOTES.md` should be updated only when their specific scope changes
- Rebuilt the Godot apartment presentation more directly from the current map and character references:
  - Shifted the room away from bunker/test-board staging toward a lived-in small apartment with bed, bathroom-door hint, window, desk/work zone, kitchen/appliance zone, rug, and small table
  - Reduced Yui's in-game visual scale and collision footprint so she reads closer to a small top-down pixel-game character
  - Repositioned the power strip as a central power hub and rerouted powered-device cables as organized dark wires instead of glowing power lines
  - Normalized powered object display sizes so devices, furniture, and player proportions are more consistent
  - Updated visual implementation, asset application, and Yui animation notes for the reference rebuild pass
- Aligned the Godot apartment presentation to the newer `map ui` and `YUI Sprite Sheet` reference specifications:
  - Replaced the in-room large PNG character display with runtime generated `32x48` pixel-style Yui frames using front/side/back silhouettes and a 4-frame walk cycle
  - Repositioned implemented objects to match the `map ui` numbered guide: bed, multitap, laptop, fan, charger, and communication device
  - Recentered the multitap as the central lower-floor power hub and rerouted cables as dark non-glowing physical wires
  - Updated object display sizes and player collision scale to better match the reference map proportions
  - Added an `AGENTS.md` rule requiring named reference images to be opened and treated as implementation specifications when requested
- Applied the actual reference images as Godot runtime assets:
  - Copied `docs/reference/map.png` into the Godot project and now draws it directly as the apartment background
  - Copied `docs/reference/YUI.png` into the Godot project and processed it into an RGBA 4-direction, 4-frame sprite sheet
  - Replaced the generated Yui placeholder frames with `AtlasTexture` frames from the processed reference YUI sheet
  - Hid duplicate placeholder object drawings while keeping the existing Area2D interaction and collision overlays aligned to the map art
  - Added `tools/process_yui_sprite_sheet.py` to reproduce the transparent YUI sheet generation
- Replaced the active player sprite source with `docs/reference/yui-1.png`:
  - Regenerated the active Yui walk sheet from `yui-1.png` instead of the older `YUI.png` source
  - Normalized all 16 frames into matching `96x96` canvases with shared foot-baseline alignment
  - Increased the active `AnimatedSprite2D` display size while keeping collision, movement, interaction, map, UI, and object placement unchanged
  - Verified the Godot main scene with a runtime screenshot at `docs/validation/yui_1_runtime_screenshot00000000.png`

## Current Goal

- Keep the active player sprite on the `yui-1` source sheet and avoid reusing the old automatic cutout result from `YUI.png`
- Continue focusing the active Godot work on DAY 1 MVP readability, outlet/power decisions, and reference-aligned apartment presentation
- Preserve the current map, UI, object placement, movement, and interaction systems while tuning only player sprite quality

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scenes/Player.tscn`
- `godot/scripts/Player.gd`
- `godot/assets/art/characters/yui/yui_1_source_sheet.png`
- `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
- `tools/process_yui_sprite_sheet.py`
- `docs/reference/yui-1.png`
- `docs/validation/yui_1_runtime_screenshot00000000.png`
- `docs/PROJECT_STATUS.md`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/YUI_ANIMATION_NOTES.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main`; pre-existing untracked Godot `.png.import` / `.uid` sidecars were present before this task
- `git rev-parse --short HEAD`: recorded task-start commit `be999d9`
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- Read `AGENTS.md` and the existing project tracking docs requested by the workflow update
- Opened and inspected `docs/reference/yui-1.png` before editing
- `docs/reference/yui-1.png`: `1254x1254`, RGBA, 4x4 frame sheet
- `tools/process_yui_sprite_sheet.py`: copied `docs/reference/yui-1.png` to `godot/assets/art/characters/yui/yui_1_source_sheet.png` and regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` as `384x384` RGBA
- Confirmed generated Yui sheet:
  - `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`: `384x384`, RGBA, `96x96` frames
  - All 16 frames have visible height `80`, bottom baseline `90`, center x near `48`, and no visible bbox touching the frame edge
  - Static fringe check after regeneration: `34,763` opaque pixels and `0` bright neutral edge pixels under the local edge-detection heuristic
- `Godot_v4.5.1-stable_win64_console.exe --version`: confirmed `4.5.1.stable.official.f62fdbde1`
- `Godot --headless --path . --import --quit`: completed successfully
- `Godot --path . --scene res://scenes/Main.tscn --resolution 1280x720 --fixed-fps 1 --quit-after 1 --write-movie ...`: completed successfully
- Runtime screenshot saved at `docs/validation/yui_1_runtime_screenshot00000000.png`
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- The direct reference map now supplies the visible apartment background; invisible interaction and collision overlays still need manual alignment review.
- Yui now uses the processed `yui-1.png` source sheet, with normalized frame size and foot baseline. The screenshot pass confirms startup display, but manual movement input should still be checked in-editor for every direction.
- The actual reference map is drawn directly as the apartment background; interaction/collision overlays need manual alignment review against the art.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Direct map background placement, Yui display, interaction hotspots, collision blockers, and prompt positions need screenshot-based review in the Godot editor.
- World object placeholder drawing is hidden for current map-visible objects; powered feedback is currently limited by the static reference map art.
- Previous primitive room/furniture drawings are no longer called in the apartment view, but several unused helper draw functions still exist in `Apartment.gd` and can be removed in a later cleanup pass.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.
- Multiple Godot `.png.import` / `.uid` sidecar files remain untracked from earlier work; they should stay out of commits unless the team decides otherwise.
- `PROJECT_STATUS.md` still carries a long accumulated completed-work list; if it becomes harder to scan, propose a split before deleting history.

## Next Recommended Task

1. Manual movement check for the `yui-1` sprite

Reason:
The runtime screenshot confirms the main scene starts and Yui displays at the new size, but automated movie capture did not press movement keys.

Start with:

- `docs/GODOT_PLAYTEST_CHECKLIST.md`
- `godot/scenes/Main.tscn`
- `godot/scenes/Player.tscn`
- `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`

Completion criteria:

- Up, down, left, and right walk animations still play in the correct directions
- The sprite does not visibly jump or clip during movement
- Interaction prompts still trigger from the expected player position

2. Adjust Yui scale/pivot only if the runtime screenshot shows issues

Reason:
The visual scale changed without touching collision. If the sprite feet do not line up with the collision origin in Godot, only the `Visual` offset/scale should be tuned.

Start with:

- `godot/scenes/Player.tscn`
- `godot/scripts/Player.gd`

Completion criteria:

- Collision still feels foot-based
- Proximity interaction still works from the expected distance
- No map, UI, object placement, or gameplay logic changes are included

3. Remove unused primitive room drawing helpers

Reason:
The actual map image now provides the apartment art, so the old primitive room drawing helpers are no longer part of the visible scene.

Start with:

- `godot/scripts/Apartment.gd`

Completion criteria:

- Dead draw helpers are removed without touching interaction, movement, power strip mode, result screen, or HUD behavior
- `git diff --check` passes
