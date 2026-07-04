# Project Status

## Snapshot

- Project: `CONCENT / 전력 부족의 시대`
- Branch: `main`
- Current commit at task start: `2a93caf`
- Phase: Quarterview object hover affordance
- Main target: Godot project under `godot/`
- Current source of truth: `AGENTS.md`, then `docs/CONCENT_PROJECT_IDENTITY.md`

## Current Direction

- `docs/CONCENT_PROJECT_IDENTITY.md` is the current game identity and direction reference.
- Main room direction is mouse-click first: object click, Yui moves, then `Use / Inspect / Cancel`.
- Power equipment direction is a modular power-board / power-tetris system, not the old simple multitap-only direction.
- Hacking direction focuses first on action infiltration and defense.
- Existing `Main.tscn` / DAY1 still exists as the protected golden path.
- `QuarterviewMain.tscn` is a production candidate skeleton, not the project start scene.

## Current Implementation State

- Current Main / DAY1: implemented top-view golden path; protected until explicit replacement approval.
- QuarterviewMain: production candidate skeleton with temporary room background, candidate interaction panel, prototype HUD with local mock state reactions, bed / desk / power / phone / food-kitchen / door candidate overlays, Day Result candidate overlay, and status logging only.
- QuarterviewRoom: candidate room shell using `RoomObjectDefinition` data, prompt / interaction signals, hover affordance, and debug overlay.
- QuarterviewGameplaySandbox: sandbox-only flow for interaction, mock panels, local clock, local result, and local test mode.
- Phone / Outlet / Result: still current Main-only production UI; not wired to QuarterviewMain.
- SurvivalState: production source of truth for day, time, power, connected / active devices, phone, and result data.
- Hacking prototypes: prototype-only; not wired to Laptop, rewards, Result, story flags, or save/load.
- Asset / atlas state: most qv / hack / ui atlas documents are documented-only; actual PNG, mapping Resource, Theme, and scene wiring are absent unless separately tracked.

## Latest Completed Work

- Project identity consolidation: added `docs/CONCENT_PROJECT_IDENTITY.md` and `docs/PROJECT_WORK_LOG.md`, and made AGENTS point to the identity document.
- Room / power / hacking design direction docs: fixed the current direction for mouse-centric room flow, desk close-up, modular power, hunger, hacking infiltration, and defense.
- Deprecated / scoped document notice pass: added targeted notices to legacy / conflict candidate docs, while leaving current source-of-truth docs unchanged.
- QuarterviewMain object hover affordance: added hover prompt / fallback outline support for click candidates and optional `RoomObjectDefinition` hover visual slots while keeping click movement and candidate overlays unchanged.
- QuarterviewMain footprint tuning: split visual body, click area, and blocker footprint candidates, and made path / collision blockers prefer floor-contact polygons over top-view rectangles.
- QuarterviewMain footprint tuning mode: added object panel outside-click close, kept guessed footprints as debug/tuning candidates unless path-enabled, and added a debug-only F3 tuning mode for selected object footprint / approach / click area inspection.
- QuarterviewMain Food / Kitchen candidate overlay: added no-op Fridge / Microwave food and cooking candidate actions while keeping hunger, inventory, SurvivalState, and DayResultPanel unwired.
- QuarterviewMain Door candidate overlay: added no-op door / hallway / outing candidate actions while keeping scene transition, outside map, story flag, and save-load unwired.
- QuarterviewMain minimum day-loop candidate: added a QuarterviewMain-only mock HUD and Day Result candidate overlay from the Bed end-day option while keeping DayResultPanel, SurvivalState, save-load, and story flags unwired.
- QuarterviewMain mock HUD state reactions: added local-only HUD changes for Bed rest, Food / Kitchen, Power, Phone, and made Day Result candidate summarize the current mock state while keeping SurvivalState, DayResultPanel, save-load, and story flags unwired.
- QuarterviewMain GUI checklist: added a focused manual GUI checklist for background, HUD, click movement, candidate panel, all current overlays, mock HUD reactions, input lock, debug, tuning, restart, and stress-click checks.
- QuarterviewMain temporary Yui spritesheet: generated idle / walk 4-direction PNG sheets and added an optional `QuarterviewPlayer` sprite loader while keeping the drawn placeholder as fallback.
- QuarterviewMain temporary Yui spritesheet verification: confirmed transparent alpha, `128x128` frame rules, and tracked the corresponding Godot `.png.import` files.
- QuarterviewMain Yui visual scale tuning: increased the temporary Yui sprite display scale and adjusted its visual offset while keeping collision / pathfinding / interaction sizing unchanged.
- QuarterviewMain Yui visual and motion tuning: set the temporary Yui sprite default scale to `1.8`, slowed idle / walk animation FPS, and reduced click / keyboard movement speed while keeping collision / pathfinding / interaction sizing unchanged.
- QuarterviewMain Yui idle stabilization: reduced temporary idle animation to `0.8 fps` and limited idle cycling to 2 frames while keeping walk FPS, visual scale, movement speed, collision, pathfinding, and interaction sizing unchanged.
- Quarterview temporary work devices atlas v1: generated `godot/assets/art/quarterview/atlases/qv_work_devices_atlas.png` as a transparent `2048x2048` imagegen atlas candidate; no region mapping Resource or scene wiring was added.
- Quarterview work devices atlas region mapping candidate: inspected the atlas alpha, documented 18 candidate rects in the temporary art manifest, and added a docs-only region preview image. No QuarterviewMain scene wiring was added.
- Quarterview work devices atlas preview scene: added a prototype-only Godot scene that creates runtime `AtlasTexture` previews for the 18 documented region candidates. It is not connected to QuarterviewMain.
- QuarterviewMain phone screen candidate / power drag prototype: added a temporary Phone UI atlas, expanded Phone use into a tabbed screen candidate, and added snap/reset module dragging to the Power equipment close-up while keeping PhoneUI, OutletMode, SurvivalState, save-load, and production power calculations unwired.
- QuarterviewMain Phone visual / Power board polish: the Phone screen candidate now composes selected `ui_phone_atlas.png` regions for frame / screen / icons, and the Power board drag prototype now blocks overlapping modules and shows valid / invalid drop previews.
- QuarterviewMain Phone / Power candidate helper split: moved Phone screen candidate UI / atlas-region composition and Power board drag / occupancy logic into dedicated Quarterview UI helper scripts while keeping QuarterviewMain as the overlay orchestration layer.
- QuarterviewMain Power Board UI atlas visual pass: added `ui_power_board_atlas.png` as a temporary transparent Power close-up atlas and made `PowerBoardCandidate.gd` optionally use atlas regions for board frame, cells, module icons, and drop preview while keeping the existing fallback shapes and no production power wiring.
- QuarterviewMain Power Board readability pass: reorganized the Power equipment close-up into Module Inventory / Power Board Grid / selected module detail columns, made the grid simple and readable by default, enlarged module blocks, and kept drag / snap / overlap invalid behavior no-op and QuarterviewMain-only.
- QuarterviewMain Power module Resource split: added `PowerModuleDefinition` and four prototype `.tres` module definitions, then made `PowerBoardCandidate.gd` load inventory / shape / description data from Resources with a local fallback.
- QuarterviewMain L-shape power module pass: changed `odd_efficiency_module` to a 3-cell L-shape candidate and made module inventory blocks, debug guides, and drag previews render from `shape_cells`.
- QuarterviewMain Power Board rotation prototype: added runtime-only module rotation for selected / dragged modules, with L-shape preview, overlap / out-of-grid cancellation, and no Resource mutation or production power wiring.
- QuarterviewMain Power Board manipulation UX fix: tightened placed / dragged module state restore, made rotation checks explicitly ignore the module's own occupied cells, and added Delete / Backspace return-to-inventory behavior.
- QuarterviewMain Power Board state-based inventory UX fix: made module state the source of truth, rebuilt inventory / board visuals from placement state, hid placed modules from inventory, collapsed remaining inventory modules upward, and added a visible `보관함으로` return button.
- QuarterviewMain Power Board state model hardening: added explicit `inventory_order`, ScrollContainer-backed inventory, shared `can_place_module(...)` checks, two-phase rotation, snapshot-based invalid drop restore, and GUT coverage for the state model.
- QuarterviewMain Power Board drag UX fix: separated click selection from threshold-based drag, kept inventory items inside ScrollContainer rows while dragging a separate ghost, and changed L-shape drop anchors to use the grabbed occupied cell.
- QuarterviewMain Bed rest candidate overlay: added a no-op rest / end-day candidate overlay from the Bed object candidate panel while keeping DayResultPanel, SurvivalState day advance, and production result flow unwired.
- QuarterviewMain Phone candidate overlay: added a no-op Phone status / charge overlay from the Phone object candidate panel while keeping PhoneUI, SurvivalState, and production battery state unwired.
- QuarterviewMain power equipment close-up candidate: added a no-op power-board style overlay from the Power object candidate panel while keeping OutletMode, SurvivalState, and production power calculation unwired.
- QuarterviewMain debug / close-up stabilization: fixed debug detail mixed-value text conversion, removed shadow warnings, and added empty-backdrop click close for the desk close-up candidate.
- QuarterviewMain desk close-up candidate: added a no-op desk close-up overlay for desk / laptop use and locked room click movement while candidate UI is open.
- QuarterviewMain interaction tuning: added object click priority, tuned approach points, clamped candidate panel placement, and reduced debug overlay text clutter.
- QuarterviewMain debug input split: separated the `D` debug toggle from movement input, limited debug keyboard movement to arrow keys, and kept normal interaction panels free of developer-only object details.
- QuarterviewMain movement/debug tuning: organized click/path tuning constants, kept debug toggle from changing room/camera/player transforms, and made D show debug overlays without reintroducing blockout visual shift.
- QuarterviewMain click pathfinding hardening: guarded empty path results and removed the `skew` shadow warning in the candidate room script.
- QuarterviewMain click movement feel: enlarged the temporary player marker and added candidate grid pathfinding around blockers for click movement and object approach.
- QuarterviewMain mouse interaction cleanup: normal view now uses mouse-click movement, object click approach, candidate interaction panel, and debug-only keyboard / blockout display.
- QuarterviewMain temporary background: added a temporary room background / reference flow while keeping production systems unwired.
- QuarterviewMain candidate skeleton: created the first production candidate scene without replacing old Main.
- CONCENT handoff / identity refresh: updated the new-session handoff and identity room direction with the latest compact room, hidden power cabinet, simplified desk, and current QuarterviewMain overlay status.

## Changed Files In Latest Work

- `godot/scripts/quarterview/QuarterviewRoom.gd`: adds hover target detection, hover prompt, fallback outline / fill, optional hover overlay texture support, and room-input-lock hover clearing.
- `godot/scripts/resources/RoomObjectDefinition.gd`: adds optional hover label / priority / texture slot fields with safe defaults.
- `godot/test/unit/test_room_object_definition.gd`, `docs/PROJECT_STATUS.md`, `docs/PROJECT_WORK_LOG.md`: validate and record the hover affordance support.

## Validation Results

- Targeted `RoomObjectDefinition` GUT passed: 7 tests.
- Full `git diff --check` is currently blocked by unrelated whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`.
- Targeted task-file `git diff --check` passed.
- Godot headless project parse passed.
- `res://scenes/QuarterviewMain.tscn` headless startup passed.
- Full GUT passed: 71 tests.

## Current Risks / Known Issues

- `PROJECT_STATUS.md` has been rotated; detailed previous history is archived at `docs/old/PROJECT_STATUS_20260628_01.md`.
- Actual implementation state must still be verified against repo files, Godot startup, and GUT results.
- Most image / atlas plans remain documented-only.
- Main / QuarterviewMain production connection still requires a dedicated approved task.
- Existing unrelated local changes were not staged.
- Deprecated / scope notices do not rewrite old content; readers must still prioritize `docs/CONCENT_PROJECT_IDENTITY.md` when conflicts appear.
- GUI confirmation should use `docs/QUARTERVIEW_GUI_CHECKLIST.md` as the current checklist for prototype HUD placement, Bed / Food / Kitchen / Power / Phone mock reactions, Day Result summary, next-day mock DAY reset, overlay close behavior, room input lock, object approach, debug / tuning controls, repeated clicks, and protected Main / DAY1 non-wiring.

## Next Recommended Task

1. QuarterviewMain GUI check:
   - Start files: `docs/QUARTERVIEW_GUI_CHECKLIST.md`, `godot/scenes/QuarterviewMain.tscn`, `godot/scenes/quarterview/QuarterviewRoom.tscn`.
   - Complete when the checklist is run in Godot GUI and pass / needs-fix items are recorded.
2. Main replacement gate review:
   - Start files: `docs/MAIN_REPLACEMENT_RISK_CHECKLIST.md`, `docs/MAIN_REPLACEMENT_WORK_PLAN.md`.
   - Complete when Go / No-Go items are reviewed before any production entry change.
3. Deprecated content consolidation:
   - Start files: `docs/DOCUMENT_INVENTORY.md`, docs marked `Superseded Notice Added`.
   - Complete when each old direction doc is either rewritten into current docs, archived with a stub, or intentionally kept as historical context.

## Archive

- Previous accumulated status: `docs/old/PROJECT_STATUS_20260628_01.md`
