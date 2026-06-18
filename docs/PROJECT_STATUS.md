# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Multitap asset UI and dynamic map wire sync
- Current branch: `main`
- Latest commit at task start: `5631e26 fix: preserve YUI back row with fixed source grid`

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
- Tuned only the completed up/back-facing Yui frames for runtime headroom:
  - Kept the active source as `docs/reference/yui-1.png`
  - Preserved the existing `96x96` canvas, runtime display scale, map, UI, object placement, and interaction logic
  - Scaled only the fourth-row completed frames to `96%` inside the same canvas for a less shrunken silhouette
  - Kept the back-row foot baseline at visible bottom `89`
  - Confirmed front, left, and right rows are pixel-identical to the previous committed sheet
  - Updated up-direction idle and two walk validation screenshots under `docs/validation/`
- Replaced the scale-only up/back-facing Yui treatment with fixed source-cell back-row copying:
  - Kept the active source as `docs/reference/yui-1.png`
  - Removed the back row from bbox, trim, alpha-crop, visible-top/bottom, recenter, and scale-normalization processing
  - Built a transparent `1256x1256` working grid with `314x314` fixed back-row cells before generating the final sheet
  - Copied the back-facing row from those fixed source cells into the generated `96x96` output frames with nearest cell resizing only
  - Confirmed the final generated back row is pixel-identical to the transparent `1256x1256` fixed-grid cell copy result
  - Confirmed front/down, left, and right rows are unchanged from the previous committed sheet
  - Saved fixed-cell, source-vs-final, full runtime, and cropped runtime validation screenshots under `docs/validation/`
- Applied the `docs/reference/Fix/` multitap asset set and dynamic map wire sync:
  - Replaced the runtime apartment map reference with the no-wire `map_base_no_wires.png` asset
  - Added the provided `powerstrip_4slot.png` and adapter PNGs to the Godot asset tree without image recreation
  - Used `map_reference_all_wires.jpeg` as reference-only wire source material; it is not drawn as the runtime map background
  - Rebuilt the multitap management overlay around draggable adapter images, 4-slot occupancy, 1-slot devices, and 2-slot Laptop placement
  - Added shared power strip connection state for slot occupancy, connected device slots, connection flags, and slot counts
  - Added separate map wire sprite nodes `WireFan`, `WireCommunication`, `WireLaptopFloor`, `WireLaptopDesk`, `WireCharger`, and `WireLamp`
  - Synced visible map wires from the same connection state used by the multitap UI; disconnected devices keep their wires hidden
  - Kept the refrigerator excluded from the connection target list
  - Added static validation screenshots for empty, single-device, Laptop 2-slot, multi-device, disconnect, and Laptop desk-wire states

## Current Goal

- Keep the Godot multitap loop readable by syncing draggable adapter connections to map wire visibility through one shared connection state
- Preserve the no-wire base map as the visible apartment background and keep wire overlays separate per device
- Keep the DAY 1 MVP focused on power decisions without adding save/load, new rooms, or unrelated UI systems

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scripts/Apartment.gd`
- `godot/scripts/Main.gd`
- `godot/scripts/SurvivalState.gd`
- `godot/scripts/ui/AssetPaths.gd`
- `godot/scripts/ui/OutletMode.gd`
- `godot/assets/art/maps/apartment/map_base_no_wires.png`
- `godot/assets/art/maps/apartment/wires/wire_fan.png`
- `godot/assets/art/maps/apartment/wires/wire_communication.png`
- `godot/assets/art/maps/apartment/wires/wire_laptop.png`
- `godot/assets/art/maps/apartment/wires/wire_laptop_desk.png`
- `godot/assets/art/maps/apartment/wires/wire_charger.png`
- `godot/assets/art/maps/apartment/wires/wire_lamp.png`
- `godot/assets/art/objects/powerstrip/powerstrip_4slot.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_1_fan.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_2_comm.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_2slot_laptop-Photoroom.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_3_charger.png`
- `godot/assets/art/objects/powerstrip/adapters/adapter_4_lamp.png`
- `docs/reference/Fix/`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/GODOT_DAY1_MVP_PLAN.md`
- `docs/GODOT_PLAYTEST_CHECKLIST.md`
- `docs/validation/powerstrip_ui_empty_inserted.png`
- `docs/validation/powerstrip_ui_single_inserted.png`
- `docs/validation/powerstrip_ui_laptop_inserted.png`
- `docs/validation/powerstrip_ui_laptop_lamp_charger_inserted.png`
- `docs/validation/map_wires_none.png`
- `docs/validation/map_wires_fan_only.png`
- `docs/validation/map_wires_multiple.png`
- `docs/validation/map_wires_after_disconnect.png`
- `docs/validation/map_wires_laptop_charger_complete.png`
- `docs/validation/map_wires_lamp_laptop_complete.png`
- `docs/validation/map_wires_laptop_charger_lamp_complete.png`
- `docs/validation/map_laptop_split_wire_fixed_only.png`
- `docs/validation/map_laptop_split_wire_anchor_compare.png`
- `docs/validation/map_laptop_split_wire_with_lamp_charger.png`
- `docs/PROJECT_STATUS.md`
- `docs/ASSET_APPLICATION_NOTES.md`

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
- `git rev-parse --short HEAD`: recorded task-start commit `8a6fe58`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- `tools/process_yui_sprite_sheet.py`: regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` from `docs/reference/yui-1.png` with a back-row-only `96%` frame scale adjustment
- Automated pixel comparison against `HEAD:godot/assets/art/characters/yui/yui_walk_4dir_rgba.png`: confirmed front, left, and right rows were unchanged; only the back row changed
- Automated frame inspection after the back-row scale pass:
  - front, left, and right frames remain unchanged at visible top `12` and bottom `89`
  - back/up frames now have visible top `16`, bottom `89`, and height `74`
  - x center remains near `48`
- `Godot_v4.5.1-stable_win64_console.exe --headless --path . --import --quit`: completed successfully after the back-row scale pass
- `Godot_v4.5.1-stable_win64_console.exe --path . --script %TEMP%/capture_yui_up_three.gd --resolution 1280x720`: completed successfully and updated one up-direction idle screenshot plus two up-direction walk screenshots
- `git status --short --branch`: confirmed current branch is `main` at this task start
- `git rev-parse --short HEAD`: recorded task-start commit `14821a7`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- Opened and inspected `docs/reference/yui-1.png` before editing; the source is `1254x1254`, RGBA, while the generated Godot sheet is `384x384` with `96x96` frames
- `tools/process_yui_sprite_sheet.py`: regenerated `godot/assets/art/characters/yui/yui_walk_4dir_rgba.png` from `docs/reference/yui-1.png` with a back-row-only transparent `1256x1256` / `314x314` fixed source-cell copy path
- Static pixel validation:
  - fixed grid size: `1256x1256`
  - fixed cell size: `314`
  - final back row exact transparent-1256-grid cell copy result: `True`
  - front/down row unchanged from `HEAD`: `True`
  - left row unchanged from `HEAD`: `True`
  - right row unchanged from `HEAD`: `True`
  - back frames have visible headroom `6px` and visible bottom `89-90`
- Source-vs-final validation images saved at:
  - `docs/validation/yui_fixed_1256_back_row_source.png`
  - `docs/validation/yui_back_row_enlarged.png`
  - `docs/validation/yui_back_source_vs_final_compare.png`
- `python -m py_compile tools/process_yui_sprite_sheet.py`: completed successfully
- `Godot_v4.5.1-stable_win64_console.exe --headless --path . --import --quit`: completed successfully, with sandbox-only AppData editor/cache directory warnings during the non-escalated import run
- `Godot_v4.5.1-stable_win64_console.exe --path . --script %TEMP%/capture_yui_fixed_back.gd --resolution 1280x720`: completed successfully with escalation and saved runtime screenshots
- Runtime screenshots saved at:
  - `docs/validation/yui_runtime_back_idle.png`
  - `docs/validation/yui_runtime_back_walk_01.png`
  - `docs/validation/yui_runtime_back_walk_02.png`
  - `docs/validation/yui_runtime_front.png`
  - `docs/validation/yui_runtime_right.png`
- Cropped runtime review images saved at:
  - `docs/validation/yui_runtime_back_idle_crop.png`
  - `docs/validation/yui_runtime_back_walk_01_crop.png`
  - `docs/validation/yui_runtime_back_walk_02_crop.png`
  - `docs/validation/yui_runtime_front_crop.png`
  - `docs/validation/yui_runtime_right_crop.png`
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
- `git status --short --branch`: confirmed current branch is `main` at this task start, with uncommitted multitap asset/UI work from the previous step still present
- `git rev-parse --short HEAD`: recorded task-start commit `5631e26`
- `git fetch origin`: updated remote refs before this task
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- Opened and inspected the `docs/reference/Fix/` asset set before editing:
  - actual base map file: `docs/reference/Fix/map_base_no_wires.png`
  - actual wire reference file: `docs/reference/Fix/map_reference_all_wires.jpeg`
  - runtime power strip/adapters: `powerstrip_4slot.png`, `adapter_1_fan.png`, `adapter_2_comm.png`, `adapter_2slot_laptop-Photoroom.png`, `adapter_3_charger.png`, `adapter_4_lamp.png`
- Static wire validation images saved at:
  - `docs/validation/map_wires_none.png`
  - `docs/validation/map_wires_fan_only.png`
  - `docs/validation/map_wires_multiple.png`
  - `docs/validation/map_wires_after_disconnect.png`
  - `docs/validation/map_wires_laptop_2slot.png`
  - `docs/validation/map_wires_laptop_charger_complete.png`
  - `docs/validation/map_wires_lamp_laptop_complete.png`
  - `docs/validation/map_wires_laptop_charger_lamp_complete.png`
  - `docs/validation/map_laptop_split_wire_fixed_only.png`
  - `docs/validation/map_laptop_split_wire_anchor_compare.png`
  - `docs/validation/map_laptop_split_wire_with_lamp_charger.png`
- Static validation confirmed:
  - empty connection state shows no map wires
  - fan-only state shows only the fan wire
  - multiple-device state shows only connected-device wires
  - disconnect state hides the removed fan wire while leaving other connected wires visible
  - laptop uses two adjacent slots and cannot start from the fourth slot
  - `WireFan`, `WireCommunication`, `WireLaptopFloor`, `WireLaptopDesk`, `WireCharger`, and `WireLamp` are independent sprite overlays driven by shared connection state
  - Laptop desk segment is split from the floor segment so it can draw above the desk/map layer
  - fridge wiring is excluded
- `docs/validation/powerstrip_ui_validation_states.png`: saved a static preview covering empty strip, 1-slot adapter connection, Laptop 2-slot connection, collision-slot rejection, and disconnect state
- Additional power strip validation screenshots saved at:
  - `docs/validation/powerstrip_ui_empty_inserted.png`
  - `docs/validation/powerstrip_ui_single_inserted.png`
  - `docs/validation/powerstrip_ui_laptop_inserted.png`
  - `docs/validation/powerstrip_ui_laptop_lamp_charger_inserted.png`
- `git diff --stat`: reviewed code/document deltas since `5631e26`
- `git diff`: inspected the current local change set; the full diff is large, so individual script and document sections were reviewed before staging
- Bundled Python/Pillow asset check: confirmed all `docs/reference/Fix/` source assets and copied Godot runtime assets exist; no missing Fix map, power strip, adapter, or wire overlay images
  - `map_base_no_wires.png`: `1448x1086`, RGB
  - `map_reference_all_wires.jpeg`: `1446x1088`, RGB, reference-only
  - `powerstrip_4slot.png`: `1448x1086`, RGBA
  - wire overlays: `1446x1088`, RGBA
  - latest Laptop adapter: `adapter_2slot_laptop-Photoroom.png`, `1254x1254`, RGBA
- `git diff --check`: passed with CRLF normalization warnings only
- `Get-Command Godot_v4.5.1-stable_win64_console.exe,Godot_v4.5.1-stable_win64.exe,Godot,Godot.exe,godot,godot4`: no Godot executable was available in PATH, including the escalated PATH check
- Godot import, Main scene launch, live multitap UI input, live 1-slot connect/disconnect, live Laptop 2-slot occupancy, live multi-device connection, and live map wire show/hide are `Manual check required` because no Godot executable was available in PATH during closeout

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- The direct reference map now supplies the visible apartment background; invisible interaction and collision overlays still need manual alignment review.
- Yui now uses the processed `yui-1.png` source sheet with normalized non-back rows and a back-row-only transparent `1256x1256` / `314x314` fixed source-cell copy path. The previous auto-trim / bbox crop / alpha-threshold crop style back-row processing has been removed from the active up/back output path, and runtime screenshots confirm the up idle and two up walk frames render with the rounded rear-head silhouette intact. Manual movement input should still be checked in-editor.
- The actual reference map is drawn directly as the apartment background; interaction/collision overlays need manual alignment review against the art.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Direct map background placement, Yui display, interaction hotspots, collision blockers, and prompt positions need screenshot-based review in the Godot editor.
- World object placeholder drawing is hidden for current map-visible objects; powered feedback is currently limited by the static reference map art.
- Previous primitive room/furniture drawings are no longer called in the apartment view, but several unused helper draw functions still exist in `Apartment.gd` and can be removed in a later cleanup pass.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.
- Existing Godot source-side `.png.import` and necessary `.uid` metadata remain tracked where already committed; newly generated untracked `.png.import` files from this multitap asset pass are excluded from this closeout per the current task request. Generated `.godot/` cache files remain excluded.
- `PROJECT_STATUS.md` still carries a long accumulated completed-work list; if it becomes harder to scan, propose a split before deleting history.
- The dynamic wire sync has static image and code-path validation, but it still needs a real Godot 4.5.1 runtime playtest because this environment could not find a Godot executable.
- The current working tree contains the multitap asset/UI work and dynamic wire work together; if runtime validation fails later, review those files as one connected work unit.
- The Laptop wire now has a separate desk segment, but the final desk-entry-to-laptop connection may still need visual tuning after in-editor review.
- Some wire endpoints and object anchors may still need small 2-6px adjustments so every wire reads as physically connected to the device body.
- The power strip adapter images are reduced and aligned to socket centers, but socket insertion/masking still needs visual review so adapters do not feel like images placed on top of the strip.

## Next Recommended Task

1. Manual Godot playtest for multitap wire sync

Reason:
Static validation confirms the intended slot and wire states, but the actual Godot scene still needs live input testing because the local environment could not find a Godot executable during closeout.

Start with:

- `godot/scenes/Main.tscn`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scripts/Apartment.gd`
- `godot/scripts/SurvivalState.gd`

Completion criteria:

- Start state shows no device wires on the map
- Connecting one device shows only that device wire
- Connecting multiple devices shows only those device wires
- Disconnecting a device immediately hides only that device wire
- Laptop occupies two adjacent slots and cannot be placed from the fourth slot

2. Tune final wire anchors

Reason:
The current Laptop desk segment and several endpoint anchors may still look slightly disconnected even though the independent overlay structure is in place.

Start with:

- `godot/scripts/Apartment.gd`
- `godot/assets/art/maps/apartment/wires/wire_laptop_desk.png`
- `docs/reference/Fix/map_reference_all_wires.jpeg`

Completion criteria:

- Laptop, charger, and lamp wires overlap their target device body by a few pixels
- No wire endpoint appears to stop in empty floor/table space
- Updated screenshots compare the adjusted wire endpoints against the reference

3. Review power strip adapter insertion masks

Reason:
The draggable adapter UI uses real PNGs and reduced connected sizes, but the socket insertion illusion still needs in-Godot visual review and possible masking adjustment.

Start with:

- `godot/scripts/ui/OutletMode.gd`
- `docs/reference/Fix/powerstrip_4slot.png`
- `godot/assets/art/objects/powerstrip/adapters/`

Completion criteria:

- 1-slot adapters visually cover the intended socket holes without oversized selection boxes
- Laptop adapter occupies two slots while its plug anchor remains aligned to the insertion slot
- Invalid drop, valid drop, and click/drag disconnect still work after visual tuning
