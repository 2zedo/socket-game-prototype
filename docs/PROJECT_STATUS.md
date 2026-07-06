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
- `QuarterviewApartmentShellCandidate` is an independent coordinate-based shell scene for validating the two-room apartment layout before final art.
- QuarterviewMain candidate features are local/mock unless explicitly wired later:
  - click movement and hover affordance
  - portable Phone opened with `P`
  - job candidate acceptance
  - Desk / Laptop, Power Board, Bed, Food / Kitchen, Door, Day Result, and Hacking Entry candidate overlays
  - local mock HUD and local candidate state
- Production `SurvivalState`, `PhoneUI`, `OutletMode`, `DayResultPanel`, save-load, Grid Credit, story flags, and Hacking scene transitions remain unwired from QuarterviewMain.

## Latest Work

- Added and refined `QuarterviewApartmentShellCandidate` as a coordinate-based Godot scene under `godot/scenes/quarterview/`.
- The scene draws the apartment shell with placeholder floor tiles, Axis A/B walls, wall caps, baseboards, door/window placeholders, debug labels, camera presets, and a foreground no-large-object zone.
- Wall segments are now editable through named `ApartmentWallSegmentConfig` entries, with `W` for wall ID markers and `I` for a console wall inventory / edit-hint table.
- The former service area is folded into the bathroom shell region; legacy service wall segments remain disabled in the inventory for reference.
- Floor grid coordinate debugging is available with `G`, including tile labels, origin / axis markers, hover cell display, click-to-print cell output, and `from_cell -> to_cell` wall inventory.
- Wall edge coordinate debugging is available with `E`, separating wall grid-line / vertex coordinates from floor cell coordinates; `G` click output now prints a cell's four wall edges, and `E` click output prints the nearest edge `from/to` pair.
- Bathroom / entrance shell walls now follow the specified grid-line coordinates: bathroom boundary `(0,7)->(2,7)`, bathroom doorway wall `(2,4)->(2,7)`, entrance inner wall `(2,7)->(2,10)`, and entrance doorway `(0,8)->(0,9)`.
- Wall segments now separate logical existence from display mode; living front/right occlusion walls are enabled logical walls but render as clearer low revealable stubs with body/cap/shadow in the current shell view.
- Living occlusion display now uses the actual outer grid-line walls: `living_right_wall` at `(11,4)->(11,10)` and `living_front_cutaway` at `(0,10)->(11,10)`; earlier one-cell-inward occlusion wall segments remain disabled as legacy references.
- Occlusion wall debugging is available with `O`, and `preview_revealed_walls` can temporarily show revealable walls at full height for shell inspection.
- Navigation / collision debugging is available with `N`, showing walkable cells, room areas, blocked wall edges, passable doorway edges, and a shell-only marker at `player_debug_cell`.
- It is independent and is not wired into `QuarterviewMain`, production `Main`, `SurvivalState`, or `project.godot`.
- Documentation now records the shell candidate path, coordinate basis, wall editing controls, navigation overlay controls, and validation command.

## Validation Notes

- This change intentionally adds one candidate scene and one candidate script, plus documentation.
- It uses generated geometry only; no image assets, imports, atlas resources, or production start scene wiring are added.
- Full `git diff --check` may still report unrelated local whitespace in `godot/addons/godot_ai/handlers/texture_handler.gd`; targeted checks should be used for current-task files if that unrelated file remains dirty.

## Next Recommended Work

1. Open `QuarterviewApartmentShellCandidate.tscn` in Godot and check whether the shared wall, internal door, foreground no-large-object zone, and camera presets match the intended floor plan.
2. Adjust only the shell coordinates until the two-room structure is stable.
3. After the shell is accepted, use it as the basis for floor/wall/door atlas replacement or final room art passes.
