# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Main target: Godot project under `godot/`
- Web prototype: React/Vite/Phaser prototype is reference only
- Current phase: Map UI and Yui sprite specification alignment pass
- Current branch: `main`
- Latest commit at task start: `0a8157d feat: rebuild apartment visual composition`

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

## Current Goal

- Verify the map UI/Yui sprite specification alignment pass in the Godot editor with screenshots
- Continue focusing the active Godot work on DAY 1 MVP readability, outlet/power decisions, and reference-aligned apartment presentation
- Tune remaining object art and character animation only after the `map ui` aligned room composition is manually reviewed

## Not Doing Yet

- DAY 2+
- save/load
- multi-ending
- complex NPC relationship system
- web prototype changes
- art polish before core playability

## Changed Files

- `godot/scripts/Apartment.gd`
- `godot/scenes/Player.tscn`
- `godot/scripts/Player.gd`
- `godot/scripts/Interactable.gd`
- `AGENTS.md`
- `docs/reference/YUI Sprite Sheet.png`
- `docs/reference/map ui.png`
- `docs/PROJECT_STATUS.md`
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md`
- `docs/ASSET_APPLICATION_NOTES.md`
- `docs/YUI_ANIMATION_NOTES.md`

## Validation Results

- `git status --short --branch`: confirmed current branch is `main`; only pre-existing untracked reference/import sidecar files were present before this task
- `git rev-parse --short HEAD`: recorded task-start commit `0a8157d`
- `git fetch origin`: updated remote refs before editing
- `git log --oneline HEAD..origin/main`: confirmed no new remote commits before editing
- Read `AGENTS.md` and the existing project tracking docs requested by the workflow update
- Opened and inspected `docs/reference/YUI Sprite Sheet.png` before editing
- Opened and inspected `docs/reference/map ui.png` before editing
- `git diff --stat`: checked visual/code/documentation/reference scope before staging
- `git diff --check`: passed
- `Get-Command godot -ErrorAction SilentlyContinue`: Godot CLI was not found in PATH
- `Get-Command godot4 -ErrorAction SilentlyContinue`: Godot 4 CLI was not found in PATH
- Godot editor/runtime validation is Manual check required
- Web validation was not run because no web files were changed

## Current Risks or Known Issues

- Existing web prototype remains a useful reference, but it should not drive broad Godot scope creep.
- Concept images define mood and direction, not exact asset requirements.
- The first DAY 1 power loop is implemented, but it still needs in-editor Godot playtesting.
- Outlet connection now gates object use, but drag/connect/disconnect behavior still needs manual playtesting in Godot.
- P0 PNG assets are now applied, but many furniture/environment details still use primitive fallback drawing.
- Yui now uses generated 32x48 pixel-style frames based on the reference sheet proportions, but final hand-authored sprite-sheet PNGs are still recommended later.
- Yui scale, foot pivot, collision radius, and 4-frame walk timing need in-editor review against furniture, prompts, and collision.
- `room_floor_base.png` and `room_wall_base.png` are drawn as underlay backdrops while existing primitive furniture/collision remains in place.
- UI panel PNGs are used as low-alpha decorative backplates because text readability remains the priority.
- Room composition, `map ui` object placement, cable routing, powered device readability, panel spacing, compact multitap section spacing, 2-slot device dragging, enlarged dialogue portrait placement, and prompt positions need another screenshot-based review in the Godot editor.
- `comm_device_off.png` and `comm_device_on.png` now have an alpha channel, but the world view still uses a smaller primitive fallback because the current product-like perspective does not blend well with the top-down room scale.
- Several furniture pieces are improved primitives, but bed/desk/door/shelf readability will eventually benefit from purpose-built room sprites.
- The exploration model is keyboard/top-down and not static point-and-click, but it still needs manual playtesting in Godot.
- Explicit End Day now exists, but still needs manual playtesting in Godot.
- Visual similarity guardrails are documented, but future UI/art passes must continue checking against them.
- The temporary device data still lives in script constants and should move to `.tres` or data files after the loop is validated.
- `docs/reference/` and multiple Godot `.png.import` / `.uid` sidecar files remain untracked from earlier work; they were not staged in this documentation workflow task.
- `PROJECT_STATUS.md` still carries a long accumulated completed-work list; if it becomes harder to scan, propose a split before deleting history.

## Next Recommended Task

1. Run the Godot editor playtest checklist for the map UI/Yui sprite alignment pass

Reason:
The current pass changed Yui sprite generation, player scale/collision, room object placement, cable routing, and multitap hub placement from the new reference specifications, but it has not been verified in the Godot editor.

Start with:

- `docs/GODOT_PLAYTEST_CHECKLIST.md`
- `godot/scenes/Main.tscn`
- `godot/scripts/Apartment.gd`
- `godot/scripts/Player.gd`

Completion criteria:

- Exploration, Interaction, Multitap, and Result states run without fatal errors
- Yui scale/pivot, object placement, cable readability, powered device feedback, day/night window readability, and enlarged dialogue portrait are checked in-editor
- Any bugs found are recorded with screenshots or clear reproduction steps

2. Decide how to handle untracked reference and Godot sidecar files

Reason:
`docs/reference/` and multiple Godot `.png.import` / `.uid` files remain untracked. Some may be intentional project documentation/assets, while others may be generated sidecars that should stay out of commits.

Start with:

- `docs/reference/`
- `godot/assets/art/**/*.png.import`
- `godot/scripts/ui/AssetPaths.gd.uid`
- `.gitignore`

Completion criteria:

- Intentional reference assets are either committed or explicitly left untracked
- Generated/cache-like files are ignored or documented as intentionally untracked
- No `.godot/` cache or unrelated temporary files are staged

3. Tune visual layout from actual Godot screenshots

Reason:
The current room and UI presentation has been rebuilt from code and reference images, but final readability depends on screenshots from the running Godot scene.

Start with:

- `godot/scripts/Apartment.gd`
- `godot/scripts/Interactable.gd`
- `godot/scripts/ui/OutletMode.gd`
- `godot/scenes/ui/InteractionPanel.tscn`

Completion criteria:

- Screenshot-based issues are fixed without adding new gameplay systems
- `docs/UI_VISUAL_IMPLEMENTATION_NOTES.md` is updated with the new visual pass
- `docs/PROJECT_STATUS.md` reflects changed files, validation, risks, and next task
