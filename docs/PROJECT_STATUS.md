# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Yui back-facing frame scale adjustment
- Current branch: `main`
- Latest commit at task start: `cc77802 fix: preserve full back-facing YUI sprite silhouette`

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
- Tracked Godot source-side metadata needed for stable asset/script imports:
  - Confirmed commit `19864bd` is included in `origin/main`
  - Kept `.godot/` cache and imported `.ctex`/`.md5` output excluded
  - Added `.gitignore` comments/negation rules documenting that source-side `.import` and `.uid` metadata should be tracked
  - Added current PNG import metadata files next to their source images
  - Added the remaining `AssetPaths.gd.uid` script UID sidecar
- Regenerated the active `yui-1` player walk sheet for directional alignment only:
  - Kept the active source as `docs/reference/yui-1.png`
  - Preserved `96x96` frames and the existing Godot runtime display scale
  - Added crop padding and stricter bbox detection so hair, lower body, and shoes are not clipped
  - Aligned all 16 frames to the same visible height, foot baseline, and x center
  - Rebuilt the right-facing row from the left-facing row mirror to avoid the bad source crop that made right movement look smaller
  - Saved four runtime direction screenshots under `docs/validation/`
- Preserved the original up/back-facing Yui silhouette:
  - Kept the active source as `docs/reference/yui-1.png`
  - Preserved the existing `96x96` canvas, runtime display scale, map, UI, object placement, and interaction logic
  - Replaced the previous back-row head repair with fixed-grid fourth-row extraction from the original source cells
  - Preserved the original back-row alpha channel instead of running alpha cleanup or bbox crop on those source cells
  - Confirmed front, left, and right rows are pixel-identical to the previous committed sheet
  - Saved up-direction idle and walk validation screenshots under `docs/validation/`
- Scaled only the completed up/back-facing Yui frames for runtime headroom:
  - Kept the active source as `docs/reference/yui-1.png`
  - Preserved the existing `96x96` canvas, runtime display scale, map, UI, object placement, and interaction logic
  - Scaled only the fourth-row completed frames to `94%` inside the same canvas
  - Kept the back-row foot baseline at visible bottom `89`
  - Confirmed front, left, and right rows are pixel-identical to the previous committed sheet
  - Updated up-direction idle and walk validation screenshots under `docs/validation/`

## Current Goal

- Keep Yui's active player sprite readable in the up/back direction without changing map, UI, object placement, interaction logic, or other direction frames
- Keep Godot source assets reproducible by tracking source-side `.import` and necessary `.uid` metadata
- Continue focusing active Godot work on DAY 1 MVP readability, outlet/power decisions, and reference-aligned apartment presentation

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`
- `tools/process_yui_sprite_sheet.py`
- `docs/validation/yui_direction_front.png`
- `docs/validation/yui_direction_back.png`
- `docs/validation/yui_direction_left.png`
- `docs/validation/yui_direction_right.png`
- `docs/validation/yui_up_idle_headroom.png`
- `docs/validation/yui_up_walk_headroom.png`
- `docs/PROJECT_STATUS.md`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/YUI_ANIMATION_NOTES.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main`; untracked Godot `.png.import` sidecars and one untracked `.uid` sidecar were present before this task
- `git rev-parse --short HEAD`: recorded task-start commit `19864bd`
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `git branch --contains 19864bd -r`: confirmed `origin/main` contains `19864bd`
- `git merge-base --is-ancestor 19864bd origin/main`: confirmed `19864bd is included in origin/main`
- `git ls-files --ignored --others --exclude-standard`: confirmed `.godot/` cache files are still ignored
- `git check-ignore -v godot/.godot/imported/...ctex`: confirmed `.godot/` imported cache remains excluded by `.gitignore`
- `Get-ChildItem -Recurse -Filter "*.png.import"`: identified source-side texture import metadata to track
- `Get-ChildItem -Recurse -Filter "*.uid"` and `git ls-files "*.uid"`: identified `AssetPaths.gd.uid` as the only remaining untracked script UID
- `Godot --headless --path . --import --quit`: completed successfully after source-side import metadata tracking
- `git status --short --branch`: confirmed current branch is `main` at task start
- `git rev-parse --short HEAD`: recorded task-start commit `d749b43`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `tools/process_yui_sprite_sheet.py`: copied `docs/reference/yui-1.png` to `godot/assets/art/characters/yui/yui_1_source_sheet.png` and regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` as `384x384` RGBA
- Automated frame inspection after regeneration:
  - all 16 frames use `96x96` canvases
  - visible height is `78` for every frame
  - bottom baseline is `89` for every frame
  - center x stays near `48`
  - no visible bbox touches the frame edge
- `Godot_v4.5.1-stable_win64_console.exe --headless --path . --import --quit`: completed successfully after regenerating the Yui sheet
- `Godot_v4.5.1-stable_win64_console.exe --path . --script %TEMP%/capture_yui_directions.gd --resolution 1280x720`: completed successfully and saved four runtime direction screenshots
- `git status --short --branch`: confirmed current branch is `main` at this task start
- `git rev-parse --short HEAD`: recorded task-start commit `613857e`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `tools/process_yui_sprite_sheet.py`: regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` from `docs/reference/yui-1.png` with fixed-grid back-row source preservation
- Automated pixel comparison against `HEAD:godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`: confirmed front, left, and right rows were unchanged; only the back row changed
- Automated frame inspection after the up-direction preservation pass:
  - front, left, and right frames remain at visible top `12` and bottom `89`
  - back/up frames use the original fourth-row source cells and remain at visible top `12` and bottom `89`
  - x center remains near `48`
- Back/up source cell inspection:
  - source fixed-grid cell sizes are `314x314`, `313x314`, `313x314`, and `314x314`
  - alignment bboxes are `130x241`, `129x238`, `130x238`, and `130x239`
  - resized fixed-grid cells are `102x102`, `103x103`, `103x103`, and `102x102`
- `Godot_v4.5.1-stable_win64_console.exe --headless --path . --import --quit`: completed successfully after the up-direction preservation pass
- `Godot_v4.5.1-stable_win64_console.exe --path . --script %TEMP%/capture_yui_up_headroom.gd --resolution 1280x720`: completed successfully and saved up-direction idle/walk screenshots
- `git status --short --branch`: confirmed current branch is `main` at this task start
- `git rev-parse --short HEAD`: recorded task-start commit `cc77802`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `tools/process_yui_sprite_sheet.py`: regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` from `docs/reference/yui-1.png` with a back-row-only `94%` frame scale adjustment
- Automated pixel comparison against `HEAD:godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`: confirmed front, left, and right rows were unchanged; only the back row changed
- Automated frame inspection after the back-row scale pass:
  - front, left, and right frames remain unchanged at visible top `12` and bottom `89`
  - back/up frames now have visible top `17`, bottom `89`, and height `73`
  - x center remains near `48`
- `Godot_v4.5.1-stable_win64_console.exe --headless --path . --import --quit`: completed successfully after the back-row scale pass
- `Godot_v4.5.1-stable_win64_console.exe --path . --script %TEMP%/capture_yui_up_headroom.gd --resolution 1280x720`: completed successfully and updated up-direction idle/walk screenshots
- Read `AGENTS.md` and the existing project tracking docs requested by the workflow update
- Opened and inspected `docs/reference/yui-1.png` before editing
- `docs/reference/yui-1.png`: `1254x1254`, RGBA, 4x4 frame sheet
- `tools/process_yui_sprite_sheet.py`: copied `docs/reference/yui-1.png` to `godot/assets/art/characters/yui/yui_1_source_sheet.png` and regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` as `384x384` RGBA
- Confirmed generated Yui sheet:
  - `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`: `384x384`, RGBA, `96x96` frames
  - All 16 frames have visible height `78`, bottom baseline `89`, center x near `48`, and no visible bbox touching the frame edge
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
- Yui now uses the processed `yui-1.png` source sheet with normalized frame size, foot baseline, side-view scale, fixed-grid preserved up/back source cells, and a back-row-only `94%` scale adjustment for headroom. Automated screenshots confirm the up idle and up walk frames render without the head touching the frame edge, but manual movement input should still be checked in-editor.
- The actual reference map is drawn directly as the apartment background; interaction/collision overlays need manual alignment review against the art.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Direct map background placement, Yui display, interaction hotspots, collision blockers, and prompt positions need screenshot-based review in the Godot editor.
- World object placeholder drawing is hidden for current map-visible objects; powered feedback is currently limited by the static reference map art.
- Previous primitive room/furniture drawings are no longer called in the apartment view, but several unused helper draw functions still exist in `Apartment.gd` and can be removed in a later cleanup pass.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.
- Godot source-side `.png.import` and necessary `.uid` metadata are now tracked; generated `.godot/` cache files remain excluded.
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
